PROJECT = aiwiki
PROJECT_DESCRIPTION = A blog application for ailink.io
PROJECT_VERSION = 0.1.0

ERLC_OPTS = +debug_info +warn_export_vars +warn_shadow_vars +warn_obsolete_guard -DENABLE_LOG

DEPS = cowboy jsx bcrypt jwt ailib aiconf aihtml aidb

dep_cowboy_commit = 2.7.0
dep_jsx_commit = v2.10.0
dep_bcrypt_commit = 1.0.2
dep_jwt = git https://github.com/DavidAlphaFox/jwt.git 0.1.9
dep_ailib = git https://github.com/DavidAlphaFox/ailib.git tag-0.4.0
dep_aiconf = git https://github.com/DavidAlphaFox/aiconf.git tag-0.1.2
dep_aihtml = git https://github.com/DavidAlphaFox/aihtml.git tag-0.2.7
dep_aidb = git https://github.com/DavidAlphaFox/aidb.git tag-0.3.1
include erlang.mk
