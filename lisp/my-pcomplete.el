(require 'cl-lib)
(require 'pcomplete)
(require 'pcmpl-unix)
(require 'pcmpl-linux)
(require 'pcmpl-gnu)

(defvar pcomplete-pacman-installed-packages
  (split-string (shell-command-to-string "pacman -Qq"))
  "p-completion candidates for `pacman' regarding installed packages")

(defvar pcomplete-pacman-web-packages
  (split-string (shell-command-to-string "pacman -Slq"))
  "p-completion candidates for `pacman' regarding packages on the web")

(defun pcomplete/pacman ()
  "Completion rule for the `pacman' command."
  (pcomplete-opt "DFQRSUilos")
  (cond ((pcomplete-test "-[DRQ][a-z]*")
         (pcomplete-here pcomplete-pacman-installed-packages))
        ((pcomplete-test "-[FS][a-z]*")
         (pcomplete-here pcomplete-pacman-web-packages))
        (t (pcomplete-here (pcomplete-entries)))))

(defun pcomplete/sudo ()
  "Completion rules for the `sudo' command."
  (let ((pcomplete-ignore-case t))
    (pcomplete-here (funcall pcomplete-command-completion-function))
    (cond ((pcomplete-test "pacman")
           (pcomplete/pacman))
          (t (while (pcomplete-here (pcomplete-entries)))))))

(defcustom pcomplete-systemctl-commands
  '("disable" "enable" "status" "start" "restart" "stop")
  "p-completion candidates for `systemctl' main commands"
  :type '(repeat (string :tag "systemctl command"))
  :group 'pcomplete)

(defvar pcomplete-systemd-units
  (split-string
   (shell-command-to-string
    "(systemctl list-units --all --full --no-legend;systemctl list-unit-files --full --no-legend)|while read -r a b; do echo \" $a\";done;"))
  "p-completion candidates for all `systemd' units")

(defvar pcomplete-systemd-user-units
  (split-string
   (shell-command-to-string
    "(systemctl list-units --user --all --full --no-legend;systemctl list-unit-files --user --full --no-legend)|while read -r a b;do echo \" $a\";done;"))
  "p-completion candidates for all `systemd' user units")

(defun pcomplete/systemctl ()
  "Completion rules for the `systemctl' command."
  (pcomplete-here (append pcomplete-systemctl-commands '("--user")))
  (cond ((pcomplete-test "--user")
         (pcomplete-here pcomplete-systemctl-commands)
         (pcomplete-here pcomplete-systemd-user-units))
        (t (pcomplete-here pcomplete-systemd-units))))

(defun pcomplete/find ()
  (let ((prec (pcomplete-arg 'last -1)))
    (cond ((and (pcomplete-match "^-" 'last)
                (string= "find" prec))
           ;; probably in sudo, work-around: increase index
           ;; otherwise pcomplete-opt returns nil
           (when (< pcomplete-index pcomplete-last)
             (pcomplete-next-arg))
           (pcomplete-opt "HLPDO"))
          ((pcomplete-match "^-" 'last)
           (while (pcomplete-here
                   '("-amin" "-anewer" "-atime" "-cmin" "-cnewer" "-context"
                     "-ctime" "-daystart" "-delete" "-depth" "-empty" "-exec"
                     "-execdir" "-executable" "-false" "-fls" "-follow" "-fprint"
                     "-fprint0" "-fprintf" "-fstype" "-gid" "-group"
                     "-help" "-ignore_readdir_race" "-ilname" "-iname"
                     "-inum" "-ipath" "-iregex" "-iwholename"
                     "-links" "-lname" "-ls" "-maxdepth"
                     "-mindepth" "-mmin" "-mount" "-mtime"
                     "-name" "-newer" "-nogroup" "-noignore_readdir_race"
                     "-noleaf" "-nouser" "-nowarn" "-ok"
                     "-okdir" "-path" "-perm" "-print"
                     "-print0" "-printf" "-prune" "-quit"
                     "-readable" "-regex" "-regextype" "-samefile"
                     "-size" "-true" "-type" "-uid"
                     "-used" "-user" "-version" "-warn"
                     "-wholename" "-writable" "-xdev" "-xtype"))))
          ((string= "-type" prec)
           (while (pcomplete-here (list "b" "c" "d" "p" "f" "l" "s" "D"))))
          ((string= "-xtype" prec)
           (while (pcomplete-here (list "b" "c" "d" "p" "f" "l" "s"))))
          ((or (string= prec "-exec")
               (string= prec "-execdir"))
           (while (pcomplete-here* (funcall pcomplete-command-completion-function)
                                   (pcomplete-arg 'last) t))))
    (while (pcomplete-here (pcomplete-dirs) nil 'identity))))

(defvar pcomplete-man-user-commands
  (split-string
   (shell-command-to-string
    "apropos -s 1 .|while read -r a b; do echo \" $a\";done;"))
  "p-completion candidates for `man' command")

(defun pcomplete/man ()
    "Completion rules for the `man' command."
    (pcomplete-here pcomplete-man-user-commands))

(defun pcomplete/ls ()
  (while (pcomplete-match "^-" 'last)
    (cond ((pcomplete-match "^-\\{2\\}" 'last)
           (while (pcomplete-here
                   '("--all" "--almost-all" "--author"
                     "--escape" "--block-size=" "--ignore-backups" "--color="
                     "--directory" "--dired" "--classify" "--file-type"
                     "--format=" "--full-time" "--group-directories-first"
                     "--no-group" "--human-readable" "--si"
                     "--dereference-command-line-symlink-to-dir"
                     "--hide=" "--indicator-style=" "--inode" "--ignore="
                     "--dereference" "--numeric-uid-gid" "--literal" "--indicator-style="
                     "--hide-control-chars" "--show-control-chars"
                     "--quote-name" "--quoting-style=" "--reverse" "--recursive"
                     "--size" "--sort=" "--time=" "--time-style=--tabsize="
                     "--width=" "--context" "--version" "--help"))))
          ((pcomplete-match "^-\\{1\\}" 'last)
           ;; probably in sudo, work-around: increase index
           ;; otherwise pcomplete-opt returns nil
           (when (< pcomplete-index pcomplete-last)
             (pcomplete-next-arg))
           (pcomplete-opt "aAbBcCdDfFgGhHiIklLmnNopqQrRsStTuUvwxXZ1"))))
  (while (pcomplete-here (pcomplete-entries) nil 'identity)))
