#!/bin/bash
#
# Shell test functions
# Copyright (C) 2016-2024 Savoir-faire Linux, Inc.

TDIR="$1"
JTEST_LOGLVL=debug # all debug error fatal info off

# _colorize: return colorized string
# arg1: color name
# arg2..: string
_colorize()
{
	local color="$1"; shift
	local text="$*"
	local nc='\033[0m'
	local c

	if [ -n "$NO_COLOR" ]; then
		printf "%s" "$text"
		return
	fi

	# Only colorize a few terminal types
	# "dumb" is the terminal type in GitHub Actions
	case "$TERM" in
	linux*|xterm*|screen*|tmux*|vt102|dumb) ;;
	*) printf "%s" "$text"; return ;;
	esac

	case "$color" in
	gray)   c='\033[1;30m' ;;
	red)    c='\033[1;31m' ;;
	green)  c='\033[1;32m' ;;
	yellow) c='\033[1;33m' ;;
	blue)   c='\033[1;34m' ;;
	purple) c='\033[1;35m' ;;
	cyan)   c='\033[1;36m' ;;

	red2)    c='\033[1;91m' ;;
	green2)  c='\033[1;92m' ;;
	yellow2) c='\033[1;93m' ;;
	blue2)   c='\033[1;94m' ;;
	purple2) c='\033[1;95m' ;;
	cyan2)   c='\033[1;96m' ;;
	white2)  c='\033[1;97m' ;;
	esac

	printf "${c}${text}${nc}"
}

# _jtest_log_init() - initialize log subsystem
declare -A _jloglevels
_jtest_log_init()
{
	local l
	local i=0

	for l in all debug error fatal info notice off; do
		_jloglevels[$l]=$i
		((i++))
	done
}

# _jtest_trap_error() - invoked when any line produces a non-zero output
_jtest_trap_error()
{
	local i

	jtest_log error "error triggered by ${BASH_SOURCE[1]}"
	_jtest_has_errors=1
}

# _jtest_trap_exit() - invoked at program exit
_jtest_trap_exit()
{
	if [ -n "$_jtest_current" ]; then
		jtest_log fatal 'crashed during "'$_jtest_current'"'
		jtest_result fail
	fi

	# always exit with error if an error occured during script execution
	if [ "$_jtest_has_errors" = "1" ]; then
		jtest_log error "returning error as ${BASH_SOURCE[1]} produced errors"
		exit 1
	fi
}

# jtest_log() - print log message
# arg1: a valid loglevel
jtest_log()
{
	local level="$1"; shift
	local color

	# filter out messages for lower loglevels
	if [ -z "${_jloglevels[$level]}" ]; then
		# invalid log level
		return 1
	elif [ "$JTEST_LOGLVL" = "off" ]; then
		# logging is off
		return 0
	elif [ ${_jloglevels[$level]} -lt ${_jloglevels[$JTEST_LOGLVL]} ]; then
		# insufficient log level
		return 0
	fi

	# per-loglevel coloring rules
	case "$level" in
	error)
		color=31 # red
		;;
	notice)
		color='0;33;40' # yellow
		;;
	*)
		;;
	esac

	echo -e "\e[${color}m[$(date +%T)|$level] $@\e[0m"
}

# jtest_prepare() - prepare next test
# arg1: "test description string"
jtest_prepare()
{
	[ -n "$1" ] || return 1
	jtest_log notice 'preparing "'$1'"'
	_jtest_current="$1"
}

# jtest_result() - report test result
# arg1: "pass", "fail" or "skip"
jtest_result()
{
	local status="$1"
	local pfx="  "

	if [ "$status" = "fail" ]; then
		pfx="**"
	elif [ "$status" = "skip" ]; then
		pfx="--"
	fi

	echo "$pfx|${status^^}|$_jtest_current" >>$TDIR/.jtest_results

	case "$status" in
		pass) status=$(_colorize green "PASS") ;;
		fail) status=$(_colorize red "FAIL") ;;
		skip) status=$(_colorize yellow2 "SKIP") ;;
	esac

	jtest_log info "result: $_jtest_current: $status"
	unset _jtest_current
}

_jtest_log_init

if [ ${BASH_VERSINFO[0]} -lt 4 ]; then
	jtest_log fatal "jtest requires a bash >4 environment"
	exit 1
fi

if [ ! -d "$TDIR" ]; then
	jtest_log fatal "test directory ($TDIR) not found"
	exit 1
fi

# we want to trap as much errors as possible
trap _jtest_trap_error ERR
trap _jtest_trap_exit EXIT

jtest_log info "-----------------------------------------------------"
jtest_log info "started from ${BASH_SOURCE[1]} in $TDIR"
