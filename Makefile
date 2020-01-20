PROJECT = aiwiki
PROJECT_DESCRIPTION = A blog application for ailink.io
PROJECT_VERSION = 0.1.0

ERLC_OPTS = +debug_info +warn_export_vars +warn_shadow_vars +warn_obsolete_guard -DENABLE_LOG

DEPS = cowboy jiffy bcrypt aijwt aiconf aihtml aidb aicache aicow

dep_cowboy_commit = 2.7.0
dep_bcrypt_commit = 1.0.2
dep_jiffy_commit = 1.0.1

dep_aijwt = git https://github.com/DavidAlphaFox/aijwt.git tag-0.1.0
dep_aidb = git https://github.com/DavidAlphaFox/aidb.git v0.4.0
dep_aiconf = git https://github.com/DavidAlphaFox/aiconf.git tag-0.1.3
dep_aihtml = git https://github.com/DavidAlphaFox/aihtml.git v0.3.4
dep_aicache = git https://github.com/DavidAlphaFox/aicache.git v0.1.0
dep_aicow = git https://github.com/DavidAlphaFox/aicow.git v0.1.1

include erlang.mk
