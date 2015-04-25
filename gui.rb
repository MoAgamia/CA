require 'java'
require './check_style'
require './datapath'
require './pipeline'



java_import 'java.awt.event.ActionListener'
java_import 'javax.swing.JButton'
java_import 'javax.swing.JFrame'
java_import 'javax.swing.JTextArea'
java_import 'javax.swing.JPanel'
java_import 'javax.swing.JLabel'
java_import 'java.awt.GridBagConstraints'
java_import 'java.awt.GridBagLayout'
java_import 'java.awt.Dimension'

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
    frame = JFrame.new("MIPS pipelined simulator")
    frame.setMinimumSize(Dimension.new(800,800))
#     frame.setSize(500,500)
    frame.setLocation((@@toolkits.getScreenSize().getWidth  - 400) / 2 , (@@toolkits.getScreenSize().getHeight - 400) / 2)

    mainPanel = JPanel.new
    gridBagLayout = GridBagLayout.new
    constraints = GridBagConstraints.new

    textArea = JTextArea.new(20,20)
#     textArea.setLineWrap(true)
    compile = JButton.new("Compile")
    play = JButton.new("Next")
    output = JLabel.new("output")

    mainPanel.setLayout(gridBagLayout)


    constraints.fill = GridBagConstraints::BOTH
    constraints.gridx = 0
    constraints.gridy = 0
    constraints.gridwidth = 2
    constraints.weightx = 1.0
    constraints.weighty = 1.0
    mainPanel.add(textArea,constraints)

    constraints.fill = GridBagConstraints::HORIZONTAL
    constraints.gridx = 0
    constraints.gridy = 1
    constraints.weightx = 1.0
    constraints.weighty = 1.0
    mainPanel.add(compile,constraints)

    constraints.fill = GridBagConstraints::HORIZONTAL
    constraints.gridx = 2
    constraints.gridy = 1
    constraints.weightx = 1.0
    constraints.weighty = 1.0
    mainPanel.add(play,constraints)

    constraints.fill = GridBagConstraints::BOTH
    constraints.gridx = 2
    constraints.gridy = 0
    constraints.weightx = 1.0
    constraints.weighty = 1.0
    constraints.gridheight = 2
    mainPanel.add(output,constraints)



    buttonAction = ButtonListener.new textArea
    compile.addActionListener buttonAction

    frame.add(mainPanel)
    frame.setDefaultCloseOperation(javax.swing.JFrame::EXIT_ON_CLOSE)
    frame.set_visible true

  end

  demo = Gui.new

end




