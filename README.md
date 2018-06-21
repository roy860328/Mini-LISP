# Mini-LISP
Compiler final project to interpreter Mini-LISP

### Test standard interpreter
<pre><code>$ cd test_data</code></pre>
Ubuntu 64bit
<pre><code>$ ./csmli < *.lsp</code></pre>
Mac
<pre><code>$ ./csmli_mac < *.lsp</code></pre>

### Test Mini_LISP interpreter
on Ubuntu 64bit

test_data can pass 1.lsp ~ 6.lsp and (print-num  ((fun (x) (+ x 1)) 3) ).
<pre><code>$ cd src</code>
<code>$ ./run.sh
<code>$ ./test < test_data/*.lsp</pre>
