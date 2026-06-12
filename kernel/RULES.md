# Source code rules:
 - A domain can expose things to other domains through `domain/domain.h,inc`
 - A `private/` can expose things to anything outside it but within such phase through `private/exposed.h,inc`
 - An `api/` can only declare functions of resposibility belong to a phase, never define.
 - Any domain is expected to have an init function, else cannot be considered a domain and should be moved to somewhere else.
 - Naming convention: **phase_domain_action**