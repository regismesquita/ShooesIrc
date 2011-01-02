require 'irc'

Shoes.app :width => 600,:height => 700 do
  stack do
    flow do
      @header = edit_line :width => 500
      @button = button :width => 80 do
        eval('@irc = Irc.new({' << @header.text << '})')
        @irc.connect
        Thread.new do
          while true
            @chatbox.text = @chatbox.text + @irc.checkReturn
          end
        end
     end
    end
    @chatbox = edit_box :width => 580 , :height => 600
    flow do
      @command = edit_line :width => 500
      button :width => 80 do
        eval('@irc.' << @command.text)
        @command.text = String.new
      end
    end
  end
end
