#!/bin/bash

# Programmable completion for the Subversion svn command under bash. Source
# this file (or on some systems add it to ~/.bash_completion and start a new
# shell) and bash's completion mechanism will know all about svn's options!
# Provides completion for the svnadmin command as well.  Who wants to read
# man pages/help text...

# Known to work with bash 2.05a with programmable completion and extended
# pattern matching enabled (use 'shopt -s extglob progcomp' to enable
# these if they are not already enabled).

_svn()
{
	local cur cmds cmdOpts pOpts mOpts rOpts qOpts nOpts optsParam opt
	local helpCmds optBase i

	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}

	# Possible expansions, without unambiguous abbreviations such as "up".
	cmds='add blame annotate praise cat checkout co cleanup commit ci \
              copy cp delete remove rm diff export help ? import info \
              list ls log merge mkdir move mv rename \
              propdel pdel propedit pedit propget pget \
              proplist plist propset pset resolved revert \
              status switch update version --version'

	if [[ $COMP_CWORD -eq 1 ]] ; then
		COMPREPLY=( $( compgen -W "$cmds" -- $cur ) )
		return 0
	fi

	# options that require a parameter
	# note: continued lines must end '|' continuing lines must start '|'
	optsParam="-r|--revision|--username|--password|--targets|
	           |-x|--extensions|-m|--message|-F|--file|--encoding|
	           |--diff-cmd|--diff3-cmd|--editor-cmd|--old|--new|
	           |--config-dir|--native-eol|--limit"

	# if not typing an option, or if the previous option required a
	# parameter, then fallback on ordinary filename expansion
	helpCmds='help|--help|h|\?'
	urlCmds='co|checkout|ls|list|cp|copy|mv|move'
	if [[ ${COMP_WORDS[1]} != @($helpCmds) ]] && \
	   [[ "$cur" != -* ]] || \
	   [[ ${COMP_WORDS[COMP_CWORD-1]} == @($optsParam) ]] ; then
		if [[ ${COMP_WORDS[1]} == @($urlCmds) ]] ; then
			_svn_url
		fi
		return 0
	fi

	pOpts="--username --password --no-auth-cache --non-interactive"
	mOpts="-m --message -F --file --encoding --force-log"
	rOpts="-r --revision"
	qOpts="-q --quiet"
	nOpts="-N --non-recursive"

	# possible options for the command
	cmdOpts=
	case ${COMP_WORDS[1]} in
	--version)
		cmdOpts="$qOpts"
		;;
	add)
		cmdOpts="--auto-props --no-auto-props --force --targets \
		         $nOpts $qOpts"
		;;
	blame|annotate|ann|praise)
		cmdOpts="$rOpts $pOpts -v --verbose"
		;;
	cat)
		cmdOpts="$rOpts $pOpts"
		;;
	checkout|co)
		cmdOpts="$rOpts $qOpts $nOpts $pOpts"
		;;
	cleanup)
		cmdOpts="--diff3-cmd"
		;;
	commit|ci)
		cmdOpts="$mOpts $qOpts $nOpts --targets --editor-cmd $pOpts"
		;;
	copy|cp)
		cmdOpts="$mOpts $rOpts $qOpts --editor-cmd $pOpts"
		;;
	delete|del|remove|rm)
		cmdOpts="--force $mOpts $qOpts --targets --editor-cmd $pOpts"
		;;
	diff|di)
		cmdOpts="$rOpts -x --extensions --diff-cmd --no-diff-deleted \
		         $nOpts $pOpts --force --old --new --notice-ancestry"
		;;
	export)
		cmdOpts="$rOpts $qOpts $pOpts --force --native-eol"
		;;
	help|h|\?)
		cmdOpts="$cmds $qOpts"
		;;
	import)
		cmdOpts="--auto-props --no-auto-props $mOpts $qOpts $nOpts \
		         --editor-cmd $pOpts"
		;; 
	info)
		cmdOpts="--targets -R --recursive"
		;;
	list|ls)
		cmdOpts="$rOpts -v --verbose -R --recursive $pOpts"
		;;
	log)
		cmdOpts="$rOpts -v --verbose --targets $pOpts --stop-on-copy \
		         --incremental --xml $qOpts --limit"
		;;
	merge)
		cmdOpts="$rOpts $nOpts $qOpts --force --dry-run --diff3-cmd \
		         $pOpts --ignore-ancestry"
		;;
	mkdir)
		cmdOpts="$mOpts $qOpts --editor-cmd $pOpts"
		;;
	move|mv|rename|ren)
		cmdOpts="$mOpts $rOpts $qOpts --force --editor-cmd $pOpts"
		;;
	propdel|pdel|pd)
		cmdOpts="$qOpts -R --recursive $rOpts --revprop $pOpts"
		;;
	propedit|pedit|pe)
		cmdOpts="$rOpts --revprop --encoding --editor-cmd $pOpts \
		         --force"
		;;
	propget|pget|pg)
		cmdOpts="-R --recursive $rOpts --revprop --strict $pOpts"
		;;
	proplist|plist|pl)
		cmdOpts="-v --verbose -R --recursive $rOpts --revprop $qOpts \
		         $pOpts"
		;;
	propset|pset|ps)
		cmdOpts="-F --file $qOpts --targets -R --recursive --revprop \
		         --encoding $pOpts $rOpts --force"
		;;
	resolved)
		cmdOpts="--targets -R --recursive $qOpts"
		;;
	revert)
		cmdOpts="--targets -R --recursive $qOpts"
		;;
	status|stat|st)
		cmdOpts="-u --show-updates -v --verbose $nOpts $qOpts $pOpts \
		         --no-ignore"
		;;
	switch|sw)
		cmdOpts="--relocate $rOpts $nOpts $qOpts $pOpts --diff3-cmd"
		;;
	update|up)
		cmdOpts="$rOpts $nOpts $qOpts $pOpts --diff3-cmd"
		;;
	version)
		cmdOpts="$qOpts"
		;;
	*)
		;;
	esac

	cmdOpts="$cmdOpts --help -h --config-dir"

	# take out options already given
	for (( i=2; i<=$COMP_CWORD-1; ++i )) ; do
		opt=${COMP_WORDS[$i]}

		case $opt in
		--*)    optBase=${opt/=*/} ;;
		-*)     optBase=${opt:0:2} ;;
		esac

		cmdOpts=" $cmdOpts "
		cmdOpts=${cmdOpts/ ${optBase} / }

		# take out alternatives and mutually exclusives
		case $optBase in
		-v)              cmdOpts=${cmdOpts/ --verbose / } ;;
		--verbose)       cmdOpts=${cmdOpts/ -v / } ;;
		-N)              cmdOpts=${cmdOpts/ --non-recursive / } ;;
		--non-recursive) cmdOpts=${cmdOpts/ -N / } ;;
		-R)              cmdOpts=${cmdOpts/ --recursive / } ;;
		--recursive)     cmdOpts=${cmdOpts/ -R / } ;;
		-x)              cmdOpts=${cmdOpts/ --extensions / } ;;
		--extensions)    cmdOpts=${cmdOpts/ -x / } ;;
		-q)              cmdOpts=${cmdOpts/ --quiet / } ;;
		--quiet)         cmdOpts=${cmdOpts/ -q / } ;;
		-h)              cmdOpts=${cmdOpts/ --help / } ;;
		--help)          cmdOpts=${cmdOpts/ -h / } ;;
		-r)              cmdOpts=${cmdOpts/ --revision / } ;;
		--revision)      cmdOpts=${cmdOpts/ -r / } ;;
		--auto-props)    cmdOpts=${cmdOpts/ --no-auto-props / } ;;
		--no-auto-props) cmdOpts=${cmdOpts/ --auto-props / } ;;

		-m|--message|-F|--file)
			cmdOpts=${cmdOpts/ --message / }
			cmdOpts=${cmdOpts/ -m / }
			cmdOpts=${cmdOpts/ --file / }
			cmdOpts=${cmdOpts/ -F / }
			;;
		esac

		# skip next option if this one requires a parameter
		if [[ $opt == @($optsParam) ]] ; then
			((++i))
		fi
	done

	COMPREPLY=( $( compgen -W "$cmdOpts" -- $cur ) )

	return 0
}
complete -F _svn -o default -o nospace svn

_svn_url ()
{
	local cur protocols path repopath tmp

	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}

	if [[ ${cur} == *:* ]] ; then
		path=${cur#file://}
		tmp=${path%svnrepo*}

		if [ "$path" != "" ] && [ "$path" != "$tmp" ]; then
			path=${tmp}svnrepo
		fi

		if [ -r "${path}/db" ]; then
			repopath=${cur#*svnrepo}

			if [[ ${repopath} == */* ]] ; then
				validpath=${repopath%\/*}
			else
				validpath=""
			fi

			files=$( svn ls file://$path$validpath )
			COMPREPLY=( $( compgen -P "//$path$validpath/" -W "$files" ${repopath##*/} ) )
		else
			COMPREPLY=( $( compgen -P "//" -S "/" -d $path ) )
		fi
	else
		protocols="svn file http ssh+svn"
		COMPREPLY=( $( compgen -S "://" -W "$protocols" $cur ) )
	fi

	return 0
}

_svnadmin ()
{
	local cur cmds cmdOpts optsParam opt helpCmds optBase i

	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}

	cmds='create deltify dump help h ? hotcopy load list-dblogs \
	      list-unused-dblogs lstxns recover rmtxns setlog verify'

	if [[ $COMP_CWORD -eq 1 ]] ; then
		COMPREPLY=( $( compgen -W "$cmds" -- $cur ) )
		return 0
	fi

	# options that require a parameter
	# note: continued lines must end '|' continuing lines must start '|'
	optsParam="-r|--revision|--parent-dir|--fs-type"

	# if not typing an option, or if the previous option required a
	# parameter, then fallback on ordinary filename expansion
	helpCmds='help|--help|h|\?'
	if [[ ${COMP_WORDS[1]} != @($helpCmds) ]] && \
	   [[ "$cur" != -* ]] || \
	   [[ ${COMP_WORDS[COMP_CWORD-1]} == @($optsParam) ]] ; then
		return 0
	fi

	cmdOpts=
	case ${COMP_WORDS[1]} in
	create)
		cmdOpts="--bdb-txn-nosync --bdb-log-keep --config-dir --fs-type"
		;;
	deltify)
		cmdOpts="-r --revision -q --quiet"
		;;
	dump)
		cmdOpts="-r --revision --incremental -q --quiet --deltas"
		;;
	help|h|\?)
		cmdOpts="$cmds $qOpts"
		;;
	hotcopy)
		cmdOpts="--clean-logs"
		;;
	load)
		cmdOpts="--ignore-uuid --force-uuid --parent-dir -q --quiet"
		;;
	list-dblogs)
		;;
	list-unused-dblogs)
		;;
	setlog)
		cmdOpts="-r --revision"
		;;
	*)
		;;
	esac

	cmdOpts="$cmdOpts --help -h"

	# take out options already given
	for (( i=2; i<=$COMP_CWORD-1; ++i )) ; do
		opt=${COMP_WORDS[$i]}

		case $opt in
		--*)    optBase=${opt/=*/} ;;
		-*)     optBase=${opt:0:2} ;;
		esac

		cmdOpts=" $cmdOpts "
		cmdOpts=${cmdOpts/ ${optBase} / }

		# take out alternatives
		case $optBase in
		-q)              cmdOpts=${cmdOpts/ --quiet / } ;;
		--quiet)         cmdOpts=${cmdOpts/ -q / } ;;
		-h)              cmdOpts=${cmdOpts/ --help / } ;;
		--help)          cmdOpts=${cmdOpts/ -h / } ;;
		-r)              cmdOpts=${cmdOpts/ --revision / } ;;
		--revision)      cmdOpts=${cmdOpts/ -r / } ;;
		esac

		# skip next option if this one requires a parameter
		if [[ $opt == @($optsParam) ]] ; then
			((++i))
		fi
	done

	COMPREPLY=( $( compgen -W "$cmdOpts" -- $cur ) )

	return 0
}
complete -F _svnadmin -o default svnadmin
