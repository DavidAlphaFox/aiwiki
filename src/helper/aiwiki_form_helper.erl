-module(aiwiki_form_helper).
-export([build/2,verify/2]).

-define(CSRF_SECTION, <<"csrf">>).
-define(SECRET,<<"secret">>).

build(Req,Method)->
  CSRFSection = chalk_conf:get_section(?CSRF_SECTION),
  Secret = proplists:get_value(?SECRET,CSRFSection),
  aicow_form:build(Secret,Req,Method).

  verify(Req,Form)->
  CSRFSection = chalk_conf:get_section(?CSRF_SECTION),
  Secret = proplists:get_value(?SECRET,CSRFSection),
  aicow_form:verify(Secret,Req,Form).