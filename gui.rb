require 'java'
# require './check_style'
require './datapath'
require './pipeline'

java_import 'java.awt.event.ActionListener'
java_import 'javax.swing.JButton'
java_import 'javax.swing.JFrame'
java_import 'javax.swing.JTextArea'
java_import 'javax.swing.JPanel'
java_import 'javax.swing.JScrollPane'

class ButtonListener
  include ActionListener

  @textArea

  def initialize text
    @textArea = text
  end

  def actionPerformed(e)
    text = @textArea.getText
    datapath = Datapath.new
    datapath.load_instructions text
    @textArea.requestFocusInWindow
  end
end


class Gui

  @@toolkits = java.awt.Toolkit.getDefaultToolkit()

  def initialize
    frame = JFrame.new
    frame.setSize(400,400)
    frame.setLocation((@@toolkits.getScreenSize().getWidth  - 400) / 2 , (@@toolkits.getScreenSize().getHeight - 400) / 2)

    button = JButton.new("Execute")

    textArea = JTextArea.new

    mainPanel = JPanel.new(java.awt.GridLayout.new(2,1,5,5))
    mainPanel.add(textArea)

    buttonAction = ButtonListener.new textArea
    button.addActionListener buttonAction

    mainPanel.add(button)

    frame.add(mainPanel)
    frame.setDefaultCloseOperation(javax.swing.JFrame::EXIT_ON_CLOSE)
    frame.set_visible true

  end
  
  demo = Gui.new

end




