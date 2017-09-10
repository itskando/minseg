/*
 * File: lab2_2.c
 *
 * Code generated for Simulink model 'lab2_2'.
 *
 * Model version                  : 1.4
 * Simulink Coder version         : 8.9 (R2015b) 13-Aug-2015
 * C/C++ source code generated on : Thu Jan 26 12:17:11 2017
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Atmel->AVR
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "lab2_2.h"
#include "lab2_2_private.h"
#include "lab2_2_dt.h"
#define lab2_2_Encoder                 (1.0)
#define lab2_2_PinA                    (19.0)
#define lab2_2_PinB                    (18.0)

/* Block signals (auto storage) */
B_lab2_2_T lab2_2_B;

/* Block states (auto storage) */
DW_lab2_2_T lab2_2_DW;

/* Real-time model */
RT_MODEL_lab2_2_T lab2_2_M_;
RT_MODEL_lab2_2_T *const lab2_2_M = &lab2_2_M_;

/* Model step function */
void lab2_2_step(void)
{
  uint8_T tmp;

  /* MATLABSystem: '<Root>/M2V3 Left Connector 18, 19' incorporates:
   *  Start for MATLABSystem: '<Root>/M2V3 Left Connector 18, 19'
   */
  lab2_2_B.M2V3LeftConnector1819 = enc_output(lab2_2_Encoder);

  /* Gain: '<Root>/Gain' incorporates:
   *  DataTypeConversion: '<Root>/Data Type Conversion'
   */
  lab2_2_B.Gain = lab2_2_P.Gain_Gain * (real_T)lab2_2_B.M2V3LeftConnector1819;

  /* DataTypeConversion: '<S1>/Data Type Conversion' */
  if (lab2_2_B.Gain < 256.0) {
    if (lab2_2_B.Gain >= 0.0) {
      tmp = (uint8_T)lab2_2_B.Gain;
    } else {
      tmp = 0U;
    }
  } else {
    tmp = MAX_uint8_T;
  }

  /* End of DataTypeConversion: '<S1>/Data Type Conversion' */

  /* S-Function (arduinoanalogoutput_sfcn): '<S1>/PWM' */
  MW_analogWrite(lab2_2_P.PWM_pinNumber, tmp);

  /* External mode */
  rtExtModeUploadCheckTrigger(1);

  {                                    /* Sample time: [0.05s, 0.0s] */
    rtExtModeUpload(0, lab2_2_M->Timing.taskTime0);
  }

  /* signal main to stop simulation */
  {                                    /* Sample time: [0.05s, 0.0s] */
    if ((rtmGetTFinal(lab2_2_M)!=-1) &&
        !((rtmGetTFinal(lab2_2_M)-lab2_2_M->Timing.taskTime0) >
          lab2_2_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(lab2_2_M, "Simulation finished");
    }

    if (rtmGetStopRequested(lab2_2_M)) {
      rtmSetErrorStatus(lab2_2_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   */
  lab2_2_M->Timing.taskTime0 =
    (++lab2_2_M->Timing.clockTick0) * lab2_2_M->Timing.stepSize0;
}

/* Model initialize function */
void lab2_2_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)lab2_2_M, 0,
                sizeof(RT_MODEL_lab2_2_T));
  rtmSetTFinal(lab2_2_M, -1);
  lab2_2_M->Timing.stepSize0 = 0.05;

  /* External mode info */
  lab2_2_M->Sizes.checksums[0] = (2524342166U);
  lab2_2_M->Sizes.checksums[1] = (4288408807U);
  lab2_2_M->Sizes.checksums[2] = (2081111177U);
  lab2_2_M->Sizes.checksums[3] = (2058421134U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[2];
    lab2_2_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    systemRan[1] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(lab2_2_M->extModeInfo,
      &lab2_2_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(lab2_2_M->extModeInfo, lab2_2_M->Sizes.checksums);
    rteiSetTPtr(lab2_2_M->extModeInfo, rtmGetTPtr(lab2_2_M));
  }

  /* block I/O */
  (void) memset(((void *) &lab2_2_B), 0,
                sizeof(B_lab2_2_T));

  /* states (dwork) */
  (void) memset((void *)&lab2_2_DW, 0,
                sizeof(DW_lab2_2_T));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    lab2_2_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 15;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.B = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.P = &rtPTransTable;
  }

  /* Start for MATLABSystem: '<Root>/M2V3 Left Connector 18, 19' */
  lab2_2_DW.obj.isInitialized = 0L;
  lab2_2_DW.objisempty = true;
  lab2_2_DW.obj.isInitialized = 1L;
  enc_init(lab2_2_Encoder, lab2_2_PinA, lab2_2_PinB);

  /* Start for S-Function (arduinoanalogoutput_sfcn): '<S1>/PWM' */
  MW_pinModeOutput(lab2_2_P.PWM_pinNumber);
}

/* Model terminate function */
void lab2_2_terminate(void)
{
  /* Start for MATLABSystem: '<Root>/M2V3 Left Connector 18, 19' incorporates:
   *  Terminate for MATLABSystem: '<Root>/M2V3 Left Connector 18, 19'
   */
  if (lab2_2_DW.obj.isInitialized == 1L) {
    lab2_2_DW.obj.isInitialized = 2L;
  }

  /* End of Start for MATLABSystem: '<Root>/M2V3 Left Connector 18, 19' */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
