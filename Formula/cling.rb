# Documentation: https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Cling < Formula
  desc "cling build with sutoiku patches"
  homepage "https://github.com/sutoiku/cling"
  version "0.3.4"
  url "https://raw.githubusercontent.com/sutoiku/cling/v#{version}/tools/packaging/cpt.py"
  sha256 "6ae8212650c921d5acfb00246b0cbf9f50f6fd9631695356b5e3ca7bbda1dc53"

  depends_on "cmake" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    system "chmod", "+x", "cpt.py"
    system "./cpt.py", "--current-dev=tar",
             "--with-clang-url=http://root.cern.ch/git/clang.git",
             "--with-llvm-url=http://root.cern.ch/git/llvm.git",
             "--with-cling-url=https://github.com/sutoiku/cling.git#v#{version}",
             "--no-test",
             "--skip-cleanup",
             "--with-cmake-flags=-DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_THREADS=OFF -DLLVM_OPTIMIZED_TABLEGEN=ON",
             "--with-workdir=#{buildpath}"

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
