/* DWARF2 EH unwinding support for C-SKY Linux.
   Copyright (C) 2018 Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

#ifndef inhibit_libc
/* Do code reading to identify a signal frame, and set the frame
   state data appropriately.  See unwind-dw2.c for the structs.  */

#include <linux/version.h>

#if (LINUX_VERSION_CODE < KERNEL_VERSION(4,0,0))
#define sc_pt_regs(x) (sc->sc_##x)
#define sc_pt_regs_tls(x) (sc->sc_exregs[15])
#else
#define sc_pt_regs(x) (sc->sc_pt_regs.x)
#define sc_pt_regs_tls(x) sc_pt_regs(x)
#endif

#include <signal.h>
#include <asm/unistd.h>

/* The third parameter to the signal handler points to something with
   this structure defined in asm/ucontext.h, but the name clashes with
   struct ucontext from sys/ucontext.h so this private copy is used.  */
typedef struct _sig_ucontext {
  unsigned long         uc_flags;
  struct _sig_ucontext  *uc_link;
  stack_t               uc_stack;
  struct sigcontext     uc_mcontext;
  sigset_t              uc_sigmask;
} _sig_ucontext_t;

#define MD_FALLBACK_FRAME_STATE_FOR csky_fallback_frame_state

static _Unwind_Reason_Code
csky_fallback_frame_state (struct _Unwind_Context *context,
                           _Unwind_FrameState *fs)
{
  u_int16_t *pc = (u_int16_t *) context->ra;
  struct sigcontext *sc;
  _Unwind_Ptr new_cfa;
  int i;
  // FIXME
  /* movi r1, __NR_rt_sigreturn; trap 0  */
#ifdef  __CSKYABIV1__
  if ((*(pc+0) == (0x6000 + (119 << 4) + 1)) && (*(pc+1) == 0x0008))
#else
  /* movi r7, __NR_rt_sigreturn; trap 0  */
  if ((*(pc+0) == 0xea07) && (*(pc+1) == 119) &&
      (*(pc+2) == 0xc000) &&  (*(pc+3) == 0x2020))
#endif
  {
    struct sigframe {
      int sig;
      int code;
      struct sigcontext *psc;
      unsigned long extramask[2]; /* _NSIG_WORDS */
      struct sigcontext sc;
    } *_rt = context->cfa;
    sc = _rt->psc; // &(_rt->sc);
  }
  /* movi r1, 127, addi r1, 32, addi r1, (_NR_rt_sigreturn - 127 - 32); trap 0  */
#ifdef  __CSKYABIV1__
  else if((*(pc+0) == (0x6000 + (127 << 4) + 1)) && (*(pc+1) == (0x2000 + (31 << 4) + 1)) &&
          (*(pc+2) == (0x2000 + ((173 - 127 - 32 - 1) << 4) + 1)) && (*(pc+3) == 0x0008))
#else
  /* movi r7, __NR_rt_sigreturn; trap 0  */
  else if ((*(pc+0) == 0xea07) && (*(pc+1) == 173) &&
      (*(pc+2) == 0xc000) &&  (*(pc+3) == 0x2020))
#endif
  {
    struct rt_sigframe {
      int sig;
      struct siginfo *pinfo;
      void* puc;
      siginfo_t info;
      ucontext_t uc;
    } *_rt = context->cfa;
    sc = &(_rt->uc.uc_mcontext);
  }
  else  return _URC_END_OF_STACK;

  new_cfa = (_Unwind_Ptr) sc->sc_pt_regs.usp;
  fs->regs.cfa_how = CFA_REG_OFFSET;
  fs->regs.cfa_reg = STACK_POINTER_REGNUM;
  fs->regs.cfa_offset = new_cfa - (_Unwind_Ptr) context->cfa;

  /* for abiv1/2, a0, a1, a2, a3 */
#ifdef  __CSKYABIV1__
#define ARG_OFF 2
#else
#define ARG_OFF 0
#endif
  fs->regs.reg[0 + ARG_OFF].how = REG_SAVED_OFFSET;
  fs->regs.reg[0 + ARG_OFF].loc.offset = (_Unwind_Ptr)&sc_pt_regs(a0) - new_cfa;

  fs->regs.reg[1 + ARG_OFF].how = REG_SAVED_OFFSET;
  fs->regs.reg[1 + ARG_OFF].loc.offset = (_Unwind_Ptr)&sc_pt_regs(a1) - new_cfa;

  fs->regs.reg[2 + ARG_OFF].how = REG_SAVED_OFFSET;
  fs->regs.reg[2 + ARG_OFF].loc.offset = (_Unwind_Ptr)&sc_pt_regs(a2) - new_cfa;

  fs->regs.reg[3 + ARG_OFF].how = REG_SAVED_OFFSET;
  fs->regs.reg[3 + ARG_OFF].loc.offset = (_Unwind_Ptr)&sc_pt_regs(a3) - new_cfa;

#ifdef  __CSKYABIV1__
  for (i = 6; i < 15; i++) {  /* for abiv1, r6~r14 */
    fs->regs.reg[i].how = REG_SAVED_OFFSET;
    fs->regs.reg[i].loc.offset = (_Unwind_Ptr)&sc_pt_regs(regs[i - 6]) - new_cfa;
  }
  /* for abiv1, r1 */
  fs->regs.reg[1].how = REG_SAVED_OFFSET;
  fs->regs.reg[1].loc.offset = (_Unwind_Ptr)&sc_pt_regs(regs[9]) - new_cfa;
#else
  for (i = 4; i < 14; i++) {  /* for abiv2, r4~r13 */
    fs->regs.reg[i].how = REG_SAVED_OFFSET;
    fs->regs.reg[i].loc.offset = (_Unwind_Ptr)&sc_pt_regs(regs[i - 4]) - new_cfa;
  }

  for (i = 16; i < 31; i++) {  /* for abiv2, r16~r30 */
    fs->regs.reg[i].how = REG_SAVED_OFFSET;
    fs->regs.reg[i].loc.offset = (_Unwind_Ptr)&sc_pt_regs(exregs[i - 16]) - new_cfa;
  }

    fs->regs.reg[31].loc.offset = (_Unwind_Ptr)&sc_pt_regs_tls(tls) - new_cfa;
  /* FIXME : hi lo ? */
#endif
  fs->regs.reg[15].how = REG_SAVED_OFFSET;
  fs->regs.reg[15].loc.offset = (_Unwind_Ptr)&sc_pt_regs(lr) - new_cfa;

  fs->regs.reg[56].how = REG_SAVED_OFFSET;
  fs->regs.reg[56].loc.offset = (_Unwind_Ptr)&sc_pt_regs(pc) - new_cfa;
  fs->retaddr_column = 56;
  fs->signal_frame = 1;

  return _URC_NO_REASON;
}

#endif
