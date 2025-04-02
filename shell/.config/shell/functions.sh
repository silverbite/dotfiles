# https://www.digitalocean.com/community/tutorials/an-introduction-to-useful-bash-aliases-and-functions
function extract {
 if [ -z "$1" ]; then
 # display usage if no parameters given
 echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
 if [ -f $1 ] ; then
     # NAME=${1%.*}
     # mkdir $NAME && cd $NAME
     case $1 in
       *.tar.bz2)   tar xvjf ../$1    ;;
       *.tar.gz)    tar xvzf ../$1    ;;
       *.tar.xz)    tar xvJf ../$1    ;;
       *.lzma)      unlzma ../$1      ;;
       *.bz2)       bunzip2 ../$1     ;;
       *.rar)       unrar x -ad ../$1 ;;
       *.gz)        gunzip ../$1      ;;
       *.tar)       tar xvf ../$1     ;;
       *.tbz2)      tar xvjf ../$1    ;;
       *.tgz)       tar xvzf ../$1    ;;
       *.zip)       unzip ../$1       ;;
       *.Z)         uncompress ../$1  ;;
       *.7z)        7z x ../$1        ;;
       *.xz)        unxz ../$1        ;;
       *.exe)       cabextract ../$1  ;;
       *)           echo "extract: '$1' - unknown archive method" ;;
     esac
 else
     echo "$1 - file does not exist"
 fi
fi
}


# Quick backup of a a file
function bu () {
    cp $1 ${1}-`date +%Y%m%d%H%M`.backup;
}

function dc () {
    builtin cd "$@" && ll
}

# From https://gist.github.com/anonymous/8cfd9652085061dbebf5
# Inspiration: http://serverfault.com/a/5551 (but basically rewritten)
function fawk() {
    USAGE="\
usage:  fawk [<awk_args>] <field_no>
        Ex: getent passwd | grep andy | fawk -F: 5
"
    if [ $# -eq 0 ]; then
        echo -e "$USAGE" >&2
        return
        #exit 1 # whoops! that would quit the shell!
    fi

    # bail if the *last* argument isn't a number (source:
    # http://stackoverflow.com/a/808740)
    last=${@:(-1)}
    if ! [ $last -eq $last ] &>/dev/null; then
        echo "FAWK! Last argument (awk field) must be numeric." >&2
        echo -e "$USAGE" >&2;
        return
    fi

    if [ $# -gt 1 ]; then
        # Source:
        # http://www.cyberciti.biz/faq/linux-unix-bsd-apple-osx-bash-get-last-argument/
        rest=${@:1:$(( $# - 1 ))}
    else
        rest='' # just to be sure
    fi
    awk $rest "{ print  \$$last }"
}

# From: https://github.com/jlevy/the-art-of-command-line#one-liners
# Run this function to get a random tip from this document (parses Markdown and extracts an item):
function taocl() {
    curl -s https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README.md |
        sed '/cowsay[.]png/d' |
        pandoc -f markdown -t html |
        xmlstarlet fo --html --dropdtd |
        xmlstarlet sel -t -v '(html/body/ul/li[count(p)>0])['$RANDOM' mod last()+1]' |
        xmlstarlet unesc | fmt -80 | iconv -t US
}

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
	local tmpFile="${@%/}.tar";
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

	size=$(
		stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}" 2> /dev/null;  # GNU `stat`
	);

	local cmd="";
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli";
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz";
		else
			cmd="gzip";
		fi;
	fi;

	echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…";
	"${cmd}" -v "${tmpFile}" || return 1;
	[ -f "${tmpFile}" ] && rm "${tmpFile}";

	zippedSize=$(
		stat -f"%z" "${tmpFile}.gz" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}.gz" 2> /dev/null; # GNU `stat`
	);

	echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully.";
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Compare original and gzipped file size
function gz() {
	local origsize=$(wc -c < "$1");
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
	printf "orig: %d bytes\n" "$origsize";
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Run `dig` and display the most useful info
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer;
}

# Normalize `open` across Linux, macOS, and Windows.
# This is needed to make the `o` function (see below) cross-platform.
if [ ! $(uname -s) = 'Darwin' ]; then
	if grep -q Microsoft /proc/version; then
		# Ubuntu on Windows using the Linux subsystem
		alias open='explorer.exe';
	else
		alias open='xdg-open';
	fi
fi

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified.";
		return 1;
	fi;

	local domain="${1}";
	echo "Testing ${domain}…";
	echo ""; # newline

	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version");
		echo "Common Name:";
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
		echo ""; # newline
		echo "Subject Alternative Name(s):";
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
		return 0;
	else
		echo "ERROR: Certificate not found.";
		return 1;
	fi;
}

# https://git.jonathanh.co.uk/jab2870/Dotfiles/src/branch/master/shells/shared/functions
# Man without options will use fzf to select a page
function man(){
	MAN="/usr/bin/man"
	if [ -n "$1" ]; then
		$MAN "$@"
		return $?
	else
		$MAN -k . | fzf --reverse --preview="echo {1,2} | sed 's/ (/./' | sed -E 's/\)\s*$//' | xargs $MAN" | awk '{print $1 "." $2}' | tr -d '()' | xargs -r $MAN
		return $?
	fi
}

function secret(){
	head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo ''
}
