#ifndef HARPER_H
#define HARPER_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

// Opaque types
typedef struct Document Document;
typedef struct LintGroup LintGroup;
typedef struct Lint Lint;

/// Returns the version of the harper-core library.
/// The returned string must be freed using `harper_free_string`.
const char* harper_version(void);

/// Frees a string that was allocated by the Rust library.
/// # Safety
/// This function is unsafe because it can cause undefined behaviour if the pointer is invalid.
void harper_free_string(char* s);

/// Creates a new document from plain English text.
/// Returns a pointer to the document, or null if there was an error.
/// The caller is responsible for freeing the document using harper_free_document.
Document* harper_create_document(const char* text);

/// Frees a document created by harper_create_document.
void harper_free_document(Document* doc);

/// Gets the full text content of the document.
/// Returns a newly allocated C string that must be freed by the caller using free().
/// Returns NULL if the document is NULL or if memory allocation fails.
char* harper_get_document_text(const Document* doc);

/// Gets the number of tokens in the document.
/// Returns 0 if the document is NULL.
int32_t harper_get_token_count(const Document* doc);

/// Creates a new lint group with curated rules for Australian English.
/// Returns a pointer to the lint group, or null if there was an error.
/// The caller is responsible for freeing the lint group using harper_free_lint_group.
LintGroup* harper_create_lint_group(void);

/// Frees a lint group created by harper_create_lint_group.
void harper_free_lint_group(LintGroup* lint_group);

/// Gets an array of lints for a document using the specified lint group.
/// Returns a pointer to an array of Lint pointers, or null if there was an error.
/// The count parameter is set to the number of lints returned.
/// The caller is responsible for freeing the lints using harper_free_lints.
Lint** harper_get_lints(const Document* doc, const LintGroup* lint_group, int32_t* count);

/// Frees an array of lints created by harper_get_lints.
void harper_free_lints(Lint** lints, int32_t count);

/// Frees a single lint.
void harper_free_lint(Lint* lint);

/// Gets the message for a lint.
/// Returns a newly allocated C string that must be freed by the caller using free().
/// Returns NULL if the lint is NULL or if memory allocation fails.
char* harper_get_lint_message(const Lint* lint);

/// Gets the start and end positions of a lint in the source text.
/// Returns true on success, false if the lint is NULL.
/// The start and end parameters are set to the character positions (0-based).
bool harper_get_lint_start_and_end(const Lint* lint, int64_t* start, int64_t* end);

/// Gets the number of suggestions for a lint.
/// Returns 0 if the lint is NULL or has no suggestions.
int harper_get_lint_suggestion_count(const Lint* lint);

/// Gets the text of a specific suggestion for a lint.
/// Returns a newly allocated C string that must be freed by the caller using free().
/// Returns NULL if the lint is NULL, the index is invalid, or if memory allocation fails.
/// The index parameter is 0-based.
char* harper_get_lint_suggestion_text(const Lint* lint, int32_t index);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // HARPER_H
