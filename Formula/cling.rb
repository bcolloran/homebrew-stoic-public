# Documentation: https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Cling < Formula
  desc "cling build with sutoiku patches"
  homepage "https://github.com/sutoiku/cling"
  version "0.3.10"
  url "https://raw.githubusercontent.com/root-mirror/root/master/interpreter/cling/tools/packaging/cpt.py"
  sha256 "db42e1b2cc6e1029302843b3a1124aee3b33f26d26a0772eb9c11a08fabef5a0"

  bottle do
    root_url "http://homebrew.stoic.com"
    cellar :any
    # sha256 "e0480e711f758b2b594fddbd7ddef25803f846997ef527ca15fa4fc4fa5d1114" => :high_sierra
    sha256 "a2919a67feec4d95df6957653cd94945897dbadb077f641ae9797469ac6c9c4c" => :mojave
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
