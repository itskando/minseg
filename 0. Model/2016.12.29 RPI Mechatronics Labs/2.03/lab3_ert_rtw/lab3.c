/*
 * File: lab3.c
 *
 * Code generated for Simulink model 'lab3'.
 *
 * Model version                  : 1.7
 * Simulink Coder version         : 8.9 (R2015b) 13-Aug-2015
 * C/C++ source code generated on : Thu Jan 26 17:58:10 2017
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Atmel->AVR
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "lab3.h"
#include "lab3_private.h"
#include "lab3_dt.h"
#define lab3_DLPFmode                  (0.0)

/* Block signals (auto storage) */
B_lab3_T lab3_B;

/* Block states (auto storage) */
DW_lab3_T lab3_DW;

/* Real-time model */
RT_MODEL_lab3_T lab3_M_;
RT_MODEL_lab3_T *const lab3_M = &lab3_M_;

/* Model step function */
void lab3_step(void)
{
  int16_T out[3];

  /* Start for MATLABSystem: '<Root>/Gyroscope' incorporates:
   *  MATLABSystem: '<Root>/Gyroscope'
   */
  MPU6050Gyro_Read(out);

  /* MATLABSystem: '<Root>/Gyroscope' incorporates:
   *  Start for MATLABSystem: '<Root>/Gyroscope'
   */
  lab3_B.Gyroscope_o1 = out[0];

  /* External mode */
  rtExtModeUploadCheckTrigger(1);

  {                                    /* Sample time: [0.03s, 0.0s] */
    rtExtModeUpload(0, lab3_M->Timing.taskTime0);
  }

  /* signal main to stop simulation */
  {                                    /* Sample time: [0.03s, 0.0s] */
    if ((rtmGetTFinal(lab3_M)!=-1) &&
        !((rtmGetTFinal(lab3_M)-lab3_M->Timing.taskTime0) >
          lab3_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(lab3_M, "Simulation finished");
    }

    if (rtmGetStopRequested(lab3_M)) {
      rtmSetErrorStatus(lab3_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++lab3_M->Timing.clockTick0)) {
    ++lab3_M->Timing.clockTickH0;
  }

  lab3_M->Timing.taskTime0 = lab3_M->Timing.clockTick0 *
    lab3_M->Timing.stepSize0 + lab3_M->Timing.clockTickH0 *
    lab3_M->Timing.stepSize0 * 4294967296.0;
}

/* Model initialize function */
void lab3_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)lab3_M, 0,
                sizeof(RT_MODEL_lab3_T));
  rtmSetTFinal(lab3_M, 9.99);
  lab3_M->Timing.stepSize0 = 0.03;

  /* External mode info */
  lab3_M->Sizes.checksums[0] = (2449170529U);
  lab3_M->Sizes.checksums[1] = (3544593428U);
  lab3_M->Sizes.checksums[2] = (3907256496U);
  lab3_M->Sizes.checksums[3] = (3654058415U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[2];
    lab3_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    systemRan[1] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(lab3_M->extModeInfo,
      &lab3_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(lab3_M->extModeInfo, lab3_M->Sizes.checksums);
    rteiSetTPtr(lab3_M->extModeInfo, rtmGetTPtr(lab3_M));
  }

  /* block I/O */
  (void) memset(((void *) &lab3_B), 0,
                sizeof(B_lab3_T));

  /* states (dwork) */
  (void) memset((void *)&lab3_DW, 0,
                sizeof(DW_lab3_T));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    lab3_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 15;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.B = &rtBTransTable;
  }

  /* Start for MATLABSystem: '<Root>/Gyroscope' */
  lab3_DW.obj.isInitialized = 0L;
  lab3_DW.objisempty = true;
  lab3_DW.obj.isInitialized = 1L;
  MPU6050Gyro_Init(lab3_DLPFmode);
}

/* Model terminate function */
void lab3_terminate(void)
{
  /* Start for MATLABSystem: '<Root>/Gyroscope' incorporates:
   *  Terminate for MATLABSystem: '<Root>/Gyroscope'
   */
  if (lab3_DW.obj.isInitialized == 1L) {
    lab3_DW.obj.isInitialized = 2L;
  }

  /* End of Start for MATLABSystem: '<Root>/Gyroscope' */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
