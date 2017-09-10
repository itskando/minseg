#ifndef __8QRJW8zO6Xs0nwwo81gbq_h__
#define __8QRJW8zO6Xs0nwwo81gbq_h__

/* Include files */
#include "simstruc.h"
#include "rtwtypes.h"
#include "multiword_types.h"
#include "slexec_vm_zc_functions.h"

/* Type Definitions */
#ifndef typedef_so_float2bytes
#define typedef_so_float2bytes

typedef struct {
  int32_T isInitialized;
} so_float2bytes;

#endif                                 /*typedef_so_float2bytes*/

#ifndef typedef_struct_T
#define typedef_struct_T

typedef struct {
  real_T f1[2];
} struct_T;

#endif                                 /*typedef_struct_T*/

#ifndef typedef_InstanceStruct_8QRJW8zO6Xs0nwwo81gbq
#define typedef_InstanceStruct_8QRJW8zO6Xs0nwwo81gbq

typedef struct {
  SimStruct *S;
  so_float2bytes sysobj;
  boolean_T sysobj_not_empty;
  void *emlrtRootTLSGlobal;
  real32_T *u0;
  uint8_T (*b_y0)[4];
  covrtInstance *covInst_CONTAINER_BLOCK_INDEX;
} InstanceStruct_8QRJW8zO6Xs0nwwo81gbq;

#endif                                 /*typedef_InstanceStruct_8QRJW8zO6Xs0nwwo81gbq*/

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
extern void method_dispatcher_8QRJW8zO6Xs0nwwo81gbq(SimStruct *S, int_T method,
  void* data);

#endif
