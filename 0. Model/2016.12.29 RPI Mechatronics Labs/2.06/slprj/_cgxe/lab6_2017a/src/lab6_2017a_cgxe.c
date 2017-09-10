/* Include files */

#include "lab6_2017a_cgxe.h"
#include "m_e9fFxW95pQs35YFmILaME.h"

unsigned int cgxe_lab6_2017a_method_dispatcher(SimStruct* S, int_T method, void*
  data)
{
  if (ssGetChecksum0(S) == 1650327226 &&
      ssGetChecksum1(S) == 517379212 &&
      ssGetChecksum2(S) == 1612090332 &&
      ssGetChecksum3(S) == 172779037) {
    method_dispatcher_e9fFxW95pQs35YFmILaME(S, method, data);
    return 1;
  }

  return 0;
}
