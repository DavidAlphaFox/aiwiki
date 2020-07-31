PROJECT = aiwiki
PROJECT_DESCRIPTION = A blog application for ailink.io
PROJECT_VERSION = 0.1.0

ERLC_OPTS = +debug_info +warn_export_vars +warn_shadow_vars +warn_obsolete_guard -DENABLE_LOG

DEPS = cowboy bcrypt aiconf  aicow

dep_cowboy_commit = 2.7.0
dep_bcrypt_commit = 1.1.1

dep_aiconf = git https://github.com/DavidAlphaFox/aiconf.git v0.1.7
dep_aicow = git https://github.com/DavidAlphaFox/aicow.git v0.1.8

include erlang.mk
