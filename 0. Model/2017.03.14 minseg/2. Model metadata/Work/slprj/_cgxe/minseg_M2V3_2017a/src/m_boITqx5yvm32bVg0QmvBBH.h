#ifndef __boITqx5yvm32bVg0QmvBBH_h__
#define __boITqx5yvm32bVg0QmvBBH_h__

/* Include files */
#include "simstruc.h"
#include "rtwtypes.h"
#include "multiword_types.h"
#include "slexec_vm_zc_functions.h"

/* Type Definitions */
#ifndef typedef_soMPU6050Accel
#define typedef_soMPU6050Accel

typedef struct {
  int32_T isInitialized;
} soMPU6050Accel;

#endif                                 /*typedef_soMPU6050Accel*/

#ifndef typedef_InstanceStruct_boITqx5yvm32bVg0QmvBBH
#define typedef_InstanceStruct_boITqx5yvm32bVg0QmvBBH

typedef struct {
  SimStruct *S;
  soMPU6050Accel sysobj;
  boolean_T sysobj_not_empty;
  void *emlrtRootTLSGlobal;
  int16_T *b_y0;
  int16_T *b_y1;
  int16_T *y2;
  covrtInstance *covInst_CONTAINER_BLOCK_INDEX;
} InstanceStruct_boITqx5yvm32bVg0QmvBBH;

#endif                                 /*typedef_InstanceStruct_boITqx5yvm32bVg0QmvBBH*/

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
extern void method_dispatcher_boITqx5yvm32bVg0QmvBBH(SimStruct *S, int_T method,
  void* data);

#endif
