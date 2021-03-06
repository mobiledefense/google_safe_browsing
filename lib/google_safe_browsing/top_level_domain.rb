module GoogleSafeBrowsing
  class TopLevelDomain

    def self.from_host(host)
      components = host.split('.')

      tlds = parse_tld_to_hash

      tld = components.pop
      components.reverse.each do |comp|
        next_tld = "#{comp}.#{tld}"

        if tlds[next_tld]
          tld = next_tld
        else
          break
        end
      end

      tld
    end

    # return array of host components (www, example, com from www.example.com)
    # taking into account of top level domains
    # e.g. 'sub.domain.example.co.uk' => [ 'sub', 'domain', 'example', 'co.uk' ]
    def self.split_from_host(host)
      components = host.split('.')

      tlds = parse_tld_to_hash

      next_tld = components[-2..-1].join('.')
      while tlds[next_tld]
        tmp = components.pop
        components[-1] = components.last + '.' + tmp
        next_tld = components[-2..-1].join('.')
      end

      components
    end

    private

    def self.parse_tld_to_hash
      hash = Hash.new(nil)
      file_name = File.dirname(__FILE__) + '/effective_tld_names.dat.txt'
      File.readlines(file_name, 'r').each do |line|
        hash[line.chomp] = true unless line[0..1] == '//'
      end
      hash
    end
  end
end
