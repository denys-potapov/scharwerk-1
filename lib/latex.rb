# compile latex
class Latex
  def self.check_all(cmd)
    child = Subprocess.popen(cmd, stdout: Subprocess::PIPE,
                                  stderr: Subprocess::PIPE)
    output, err = child.communicate
    raise err unless child.wait.success?
    output
  end

  def self.pdf_to_png(source, out)
    check_all(['pdftoppm', source, out, '-png'])
  end

  def self.prepare_tex(filename)
    path = File.dirname(filename)
    dir = File.join(path, File.basename(filename, File.extname(filename)))
    FileUtils.mkdir_p(dir)
    FileUtils.rm_r Dir.glob(dir + '/*')

    content = '\begin{}'\
              '\input(../' + File.basename(filename) +
              '\end'
    File.write(File.join(dir, 'main.tex'), content)
  end
end
