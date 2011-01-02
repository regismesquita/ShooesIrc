require 'socket'
class Irc

  attr_accessor :connection , :server , :port , :nick, :user

  def initialize(args = {})
    @server = args[:server] || 'irc.freenode.org'
    @port = args[:port] || '6667'
    @nick = args[:nick] || 'guest'
    @user = args[:user] || 'RubyIrcUser'
  end

  def hooray
   horray = "USER #{@nick} 8 * :#{@nick} \n" 
   horray << "NICK #{@nick}"
   return horray
  end

  def send_hooray
    @connection.puts(hooray)
  end

  def talking_to=(who)
    @talking_to = who
  end

  def talk(message)
    @connection.puts('PRIVMSG '<< @talking_to << ' :' << message)
  end

  def join(channel)
    @connection.puts('JOIN #' << channel)
    @talking_to='#'<<channel
  end

  def part(channel)
    @connection.puts('PART #' << channel)
  end

  def nick=(nick)
    @connection.puts('NICK ' << nick)
    @nick = nick
  end

  def pvt(nick)
    @talking_to=nick
  end

  def connect
    ircConnection = TCPSocket.open(@server, @port)    
    ircConnection.recv(10000)
    ircConnection.puts hooray
    @connection = ircConnection
    read
  end

  def read
    Thread.new do
      retorno = @connection.recv(10000)
      retorno.each_line do |retorno_line|
        if retorno_line.match(/PING :/)
          pong_connection(retorno_line)
        end
        returnado= returnado + retorno_line
      end
      read
    end
  end

  def returnado
    @return || String.new
  end
  def returnado=value
      @return=value
  end
  def checkReturn
    return_old = @return 
    @return = String.new
    return return_old
  end

  def pong_connection(line)
    @connection.puts(line.sub(/PING/,'PONG'))
  end

end

