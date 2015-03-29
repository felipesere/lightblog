module LightBlog
  class Filesystem
    def initialize(path)
      @path = path
    end

    def all
      Dir.entries(@path)
        .select { |file| regular_file(file) }
        .map { |file| read(file) }
    end

    private
      def regular_file(file)
        !File.directory?("#{@path}/#{file}")
      end

      def read(file)
        File.read("#{@path}/#{file}")
      end
  end
end
