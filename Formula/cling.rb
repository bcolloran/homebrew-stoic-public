# Documentation: https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Cling < Formula
  desc "cling build with sutoiku patches"
  homepage "https://github.com/sutoiku/cling"
  version "0.3.7"
  url "https://raw.githubusercontent.com/root-mirror/root/master/interpreter/cling/tools/packaging/cpt.py"
  sha256 "d6bdeba5359b1a54a57f5e617aaa55f1c4dd94a6b5397295952919506c8ba35f"

  bottle do
    root_url "http://homebrew.stoic.com"
    cellar :any
    sha256 "1decc1680ce31e7d57a6a1de5cc8f7641682b5cbaa17f7598d1ec3a48f8b0481" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    system "chmod", "+x", "cpt.py"
    system "./cpt.py", "--current-dev=tar",
             "--with-clang-url=http://root.cern.ch/git/clang.git",
             "--with-llvm-url=http://root.cern.ch/git/llvm.git",
             "--with-cling-url=https://github.com/sutoiku/cling.git",
             "--no-test",
             "--skip-cleanup",
             "--with-cmake-flags=-DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_THREADS=OFF -DLLVM_OPTIMIZED_TABLEGEN=ON",
             "--with-workdir=#{buildpath}"
    
    system "make", "-j8", "--directory", "#{buildpath}/builddir/", "install"
    
    system "mkdir", "-p", "#{prefix}/include"
    system "mkdir", "-p", "#{prefix}/lib"
    system "/bin/sh", "-c", "cp -r #{buildpath}/builddir/include/* #{prefix}/include/"
    system "/bin/sh", "-c", "cp -r #{buildpath}/cling-src/tools/cling/include/* #{prefix}/include/"
    system "/bin/sh", "-c", "cp -r #{buildpath}/cling-src/include/* #{prefix}/include/"
    system "/bin/sh", "-c", "cp -r #{buildpath}/builddir/lib/clang #{prefix}/lib/"
    system "/bin/sh", "-c", "cp -r #{buildpath}/builddir/lib/libcling.dylib #{prefix}/lib/"
  end

  test do
  end
end
