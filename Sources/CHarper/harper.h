#ifndef HARPER_H
#define HARPER_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/// Returns the version of the harper-core library.
/// The returned string must be freed using `harper_free_string`.
const char* harper_version(void);

/// Frees a string that was allocated by the Rust library.
void harper_free_string(char* s);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // HARPER_H
