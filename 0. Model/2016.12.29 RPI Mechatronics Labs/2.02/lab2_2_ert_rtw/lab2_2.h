/*
 * File: lab2_2.h
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

#ifndef RTW_HEADER_lab2_2_h_
#define RTW_HEADER_lab2_2_h_
#include <float.h>
#include <string.h>
#include <stddef.h>
#ifndef lab2_2_COMMON_INCLUDES_
# define lab2_2_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_extmode.h"
#include "sysran_types.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "dt_info.h"
#include "ext_work.h"
#include "encoder_arduino.h"
#include "arduino_analogoutput_lct.h"
#endif                                 /* lab2_2_COMMON_INCLUDES_ */

#include "lab2_2_types.h"

/* Shared type includes */
#include "multiword_types.h"
#include "MW_target_hardware_resources.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetFinalTime
# define rtmGetFinalTime(rtm)          ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetRTWExtModeInfo
# define rtmGetRTWExtModeInfo(rtm)     ((rtm)->extModeInfo)
#endif

#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
# define rtmGetStopRequested(rtm)      ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
# define rtmSetStopRequested(rtm, val) ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
# define rtmGetStopRequestedPtr(rtm)   (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
# define rtmGetT(rtm)                  ((rtm)->Timing.taskTime0)
#endif

#ifndef rtmGetTFinal
# define rtmGetTFinal(rtm)             ((rtm)->Timing.tFinal)
#endif

/* Block signals (auto storage) */
typedef struct {
  real_T Gain;                         /* '<Root>/Gain' */
  int32_T M2V3LeftConnector1819;       /* '<Root>/M2V3 Left Connector 18, 19' */
} B_lab2_2_T;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  struct {
    void *LoggedData[2];
  } Scope_PWORK;                       /* '<Root>/Scope' */

  void *M2V3LeftConnector1819_PWORK;   /* '<Root>/M2V3 Left Connector 18, 19' */
  Encoder_arduino_lab2_2_T obj;        /* '<Root>/M2V3 Left Connector 18, 19' */
  boolean_T objisempty;                /* '<Root>/M2V3 Left Connector 18, 19' */
} DW_lab2_2_T;

/* Parameters (auto storage) */
struct P_lab2_2_T_ {
  uint32_T PWM_pinNumber;              /* Mask Parameter: PWM_pinNumber
                                        * Referenced by: '<S1>/PWM'
                                        */
  real_T Gain_Gain;                    /* Expression: 1 / (15 * 12 * 4)
                                        * Referenced by: '<Root>/Gain'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_lab2_2_T {
  const char_T *errorStatus;
  RTWExtModeInfo *extModeInfo;

  /*
   * Sizes:
   * The following substructure contains sizes information
   * for many of the model attributes such as inputs, outputs,
   * dwork, sample times, etc.
   */
  struct {
    uint32_T checksums[4];
  } Sizes;

  /*
   * SpecialInfo:
   * The following substructure contains special information
   * related to other components that are dependent on RTW.
   */
  struct {
    const void *mappingInfo;
  } SpecialInfo;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    time_T taskTime0;
    uint32_T clockTick0;
    time_T stepSize0;
    time_T tFinal;
    boolean_T stopRequestedFlag;
  } Timing;
};

/* Block parameters (auto storage) */
extern P_lab2_2_T lab2_2_P;

/* Block signals (auto storage) */
extern B_lab2_2_T lab2_2_B;

/* Block states (auto storage) */
extern DW_lab2_2_T lab2_2_DW;

/* Model entry point functions */
extern void lab2_2_initialize(void);
extern void lab2_2_step(void);
extern void lab2_2_terminate(void);

/* Real-time Model object */
extern RT_MODEL_lab2_2_T *const lab2_2_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'lab2_2'
 * '<S1>'   : 'lab2_2/PWM'
 */
#endif                                 /* RTW_HEADER_lab2_2_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
