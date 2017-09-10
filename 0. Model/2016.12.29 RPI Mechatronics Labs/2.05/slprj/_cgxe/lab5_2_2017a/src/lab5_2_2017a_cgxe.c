/* Include files */

#include "lab5_2_2017a_cgxe.h"
#include "m_xBxnxqfUTgHAmN996LyRwC.h"

unsigned int cgxe_lab5_2_2017a_method_dispatcher(SimStruct* S, int_T method,
  void* data)
{
  if (ssGetChecksum0(S) == 3872133371 &&
      ssGetChecksum1(S) == 390112536 &&
      ssGetChecksum2(S) == 1188850261 &&
      ssGetChecksum3(S) == 3374401860) {
    method_dispatcher_xBxnxqfUTgHAmN996LyRwC(S, method, data);
    return 1;
  }

  return 0;
}
