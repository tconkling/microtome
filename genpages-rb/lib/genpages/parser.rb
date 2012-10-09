require 'strscan'

module Genpages
    class Parser
        def parse(string)
            @scanner = StringScanner.new(string)
            PageSpec.new
        end

        def cur_line_number
            # save our current position
            saved = @scanner.pos

            # count the number of newlines
            @scanner.reset
            newlines = 0
            while @scanner.pos <= saved && @scanner.skip(/\n/)
                newlines += 1
            end

            # restore
            @scanner.pos = saved
        end
    end
end
