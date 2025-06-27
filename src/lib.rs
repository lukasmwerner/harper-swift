use harper_core::core_version;
use std::ffi::CString;
use std::os::raw::c_char;

/// Returns the version of the harper-core library as a C string.
/// The caller is responsible for freeing the returned string using `harper_free_string`.
#[no_mangle]
pub extern "C" fn harper_version() -> *mut c_char {
    CString::new(core_version())
        .expect("Failed to create CString")
        .into_raw()
}

/// Frees a string that was allocated by Rust and passed to C.
/// # Safety
/// This function is unsafe because it can cause undefined behaviour if the pointer is invalid.
#[no_mangle]
pub unsafe extern "C" fn harper_free_string(s: *mut c_char) {
    if !s.is_null() {
        let _ = CString::from_raw(s);
    }
}
