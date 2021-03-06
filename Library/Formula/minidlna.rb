require "formula"

class Minidlna < Formula
  homepage "http://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.1.4/minidlna-1.1.4.tar.gz"
  sha1 "56f333f8af91105ce5f0861d1f1918ebf5b0a028"

  bottle do
    cellar :any
    sha1 "bd843e38e01a181921457a08eefc9b834e1affe6" => :mavericks
    sha1 "f1026dd21804ccb34ccd95bf15dba43f0918b1b5" => :mountain_lion
    sha1 "454dd23d6db2a9eefb03a7d5cdfb2323de7e6d48" => :lion
  end

  head do
    url "git://git.code.sf.net/p/minidlna/git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gettext" => :build
    depends_on "xz" => :build
  end

  depends_on "libexif"
  depends_on "jpeg"
  depends_on "libid3tag"
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"
  depends_on "ffmpeg"

  def install
    ENV.append_to_cflags "-std=gnu89"
    system "./autogen.sh" if build.head?
    system "./configure", "--exec-prefix=#{prefix}"
    system "make", "install"
    sample_config_path.write sample_config
  end

  def caveats; <<-EOS.undent
      Simple single-user configuration:

      mkdir -p ~/.config/minidlna
      cp #{sample_config_path} ~/.config/minidlna/minidlna.conf
      ln -s YOUR_MEDIA_DIR ~/.config/minidlna/media
      minidlnad -f ~/.config/minidlna/minidlna.conf -P ~/.config/minidlna/minidlna.pid
    EOS
  end

  def sample_config_path
    share + "minidlna/minidlna.conf"
  end

  def sample_config; <<-EOS.undent
    friendly_name=Mac DLNA Server
    media_dir=#{ENV['HOME']}/.config/minidlna/media
    db_dir=#{ENV['HOME']}/.config/minidlna/cache
    log_dir=#{ENV['HOME']}/.config/minidlna
    EOS
  end

  test do
    system "#{sbin}/minidlnad", "-V"
  end
end
