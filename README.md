An utility, which allows to generate any kind of software development projects using generic templates. It was initially created to be used with SublimeText, hence all examples are given for SublimeText projects.

Usage: 
<pre>
  $ gensp <template-directory> <output-directory> [answers-file]
</pre>
  
The utility reads all subdirectories and files in the <template-directory> and searches for patterns surrounded by tags '{-!' and '!-}' in the template subdirectory names, files names and <i>inside</i> any files. When it finds the pattern, it attempts to replace it with a value from the optional 'answers-file' provided in the command line or emits a prompt, which asks the user to provide a value, which be used to replace the pattern.

The 'answers-file' format is the following:

<pre>
<key>=<value>
<key>=<value>
...
etc.
</pre>

