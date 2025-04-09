## Test environment

- Pop! OS 22.04, R 4.1.2

## Initial Comments to CRAN

R CMD check done via `devtools::check()`, resulting in 0 errors, 0 warnings and 0 notes.

`devtools::spell_check()` results in a lot of typos, all of which are false positives.

This is a new package of mine that I want as an initial development offering.

## Feedback upon initial rejection

CRAN requested a few clarification about what the package is in light of what was included in the DESCRIPTION file. I want to summarize the changes below in light of the initial feedback.

1. DESCRIPTION does not make explicit reference to another package or methods contained therein. Thus, I don't think it's necessary to cite anything in DESCRIPTION that wouldn't be better served in individual documentation files.

2. The original submission was entirely data without any reproducible examples/tests. I've changed this in a few ways. For one, the data have small executable "examples" that at least draw attention to the basic attributes and structure of the data. Two, I included a helper function I was using anyway for creating some of these data. I included some tests on that function in this package as well.
