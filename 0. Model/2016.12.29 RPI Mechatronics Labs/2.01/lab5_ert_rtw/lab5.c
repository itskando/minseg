/*
 * File: lab5.c
 *
 * Code generated for Simulink model 'lab5'.
 *
 * Model version                  : 1.5
 * Simulink Coder version         : 8.9 (R2015b) 13-Aug-2015
 * C/C++ source code generated on : Tue Mar 21 17:31:11 2017
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Atmel->AVR
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "lab5.h"
#include "lab5_private.h"

/* Block states (auto storage) */
DW_lab5_T lab5_DW;

/* Real-time model */
RT_MODEL_lab5_T lab5_M_;
RT_MODEL_lab5_T *const lab5_M = &lab5_M_;

/* Model step function */
void lab5_step(void)
{
  uint8_T rtb_FixPtSum1;
  uint8_T tmp;

  /* S-Function (arduinoserialwrite_sfcn): '<Root>/Serial Transmit' incorporates:
   *  UnitDelay: '<S1>/Output'
   */
  tmp = lab5_DW.Output_DSTATE;
  Serial_write(lab5_P.SerialTransmit_p1, &tmp, 1UL);

  /* Sum: '<S2>/FixPt Sum1' incorporates:
   *  Constant: '<S2>/FixPt Constant'
   *  UnitDelay: '<S1>/Output'
   */
  rtb_FixPtSum1 = (uint8_T)((uint16_T)lab5_DW.Output_DSTATE +
    lab5_P.FixPtConstant_Value);

  /* Switch: '<S3>/FixPt Switch' */
  if (rtb_FixPtSum1 > lab5_P.CounterLimited_uplimit) {
    /* Update for UnitDelay: '<S1>/Output' incorporates:
     *  Constant: '<S3>/Constant'
     */
    lab5_DW.Output_DSTATE = lab5_P.Constant_Value;
  } else {
    /* Update for UnitDelay: '<S1>/Output' */
    lab5_DW.Output_DSTATE = rtb_FixPtSum1;
  }

  /* End of Switch: '<S3>/FixPt Switch' */
}

/* Model initialize function */
void lab5_initialize(void)
{
  /* Registration code */

  /* initialize error status */
  rtmSetErrorStatus(lab5_M, (NULL));

  /* states (dwork) */
  (void) memset((void *)&lab5_DW, 0,
                sizeof(DW_lab5_T));

  /* InitializeConditions for UnitDelay: '<S1>/Output' */
  lab5_DW.Output_DSTATE = lab5_P.Output_InitialCondition;
}

/* Model terminate function */
void lab5_terminate(void)
{
  /* (no terminate code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
