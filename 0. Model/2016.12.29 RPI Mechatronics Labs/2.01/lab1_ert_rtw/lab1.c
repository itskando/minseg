/*
 * File: lab1.c
 *
 * Code generated for Simulink model 'lab1'.
 *
 * Model version                  : 1.2
 * Simulink Coder version         : 8.9 (R2015b) 13-Aug-2015
 * C/C++ source code generated on : Tue Mar 21 16:59:10 2017
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Atmel->AVR
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "lab1.h"
#include "lab1_private.h"

/* Block states (auto storage) */
DW_lab1_T lab1_DW;

/* Real-time model */
RT_MODEL_lab1_T lab1_M_;
RT_MODEL_lab1_T *const lab1_M = &lab1_M_;

/* Model step function */
void lab1_step(void)
{
  real_T rtb_Gain;
  uint8_T rtb_Gain_0;

  /* DiscretePulseGenerator: '<Root>/Pulse Generator' */
  rtb_Gain = (lab1_DW.clockTickCounter < lab1_P.PulseGenerator_Duty) &&
    (lab1_DW.clockTickCounter >= 0L) ? lab1_P.PulseGenerator_Amp : 0.0;
  if (lab1_DW.clockTickCounter >= lab1_P.PulseGenerator_Period - 1.0) {
    lab1_DW.clockTickCounter = 0L;
  } else {
    lab1_DW.clockTickCounter++;
  }

  /* End of DiscretePulseGenerator: '<Root>/Pulse Generator' */

  /* ManualSwitch: '<Root>/Manual Switch' incorporates:
   *  Constant: '<Root>/Constant'
   */
  if (lab1_P.ManualSwitch_CurrentSetting == 1) {
    rtb_Gain = lab1_P.Constant_Value;
  }

  /* End of ManualSwitch: '<Root>/Manual Switch' */

  /* Gain: '<Root>/Gain' */
  rtb_Gain *= lab1_P.Gain_Gain;

  /* DataTypeConversion: '<S1>/Data Type Conversion' */
  if (rtb_Gain < 256.0) {
    if (rtb_Gain >= 0.0) {
      rtb_Gain_0 = (uint8_T)rtb_Gain;
    } else {
      rtb_Gain_0 = 0U;
    }
  } else {
    rtb_Gain_0 = MAX_uint8_T;
  }

  /* End of DataTypeConversion: '<S1>/Data Type Conversion' */

  /* S-Function (arduinoanalogoutput_sfcn): '<S1>/PWM' */
  MW_analogWrite(lab1_P.PWM_pinNumber, rtb_Gain_0);
}

/* Model initialize function */
void lab1_initialize(void)
{
  /* Registration code */

  /* initialize error status */
  rtmSetErrorStatus(lab1_M, (NULL));

  /* states (dwork) */
  (void) memset((void *)&lab1_DW, 0,
                sizeof(DW_lab1_T));

  /* Start for DiscretePulseGenerator: '<Root>/Pulse Generator' */
  lab1_DW.clockTickCounter = 0L;

  /* Start for S-Function (arduinoanalogoutput_sfcn): '<S1>/PWM' */
  MW_pinModeOutput(lab1_P.PWM_pinNumber);
}

/* Model terminate function */
void lab1_terminate(void)
{
  /* (no terminate code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
