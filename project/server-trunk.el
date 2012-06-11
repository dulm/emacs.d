(project-def "server-trunk"
      '((basedir          "E:/Project/Tale/Server/trunk/script")
        (src-patterns     ("*.lua") ("*.cpp"))
        ;;(subdir     ("scene/" "util/"))
        ;;(vcs              svn)
        ;(open-files-cache "p_cache")
        (startup-hook    project-index)
        ))

(provide 'server-trunk)