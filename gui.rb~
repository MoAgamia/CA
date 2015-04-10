require 'java'
class Gui
  @@panels = javax.swing.JPanel
  @@frames = javax.swing.JFrame
  @@toolkits = java.awt.Toolkit.getDefaultToolkit()
  def initialize
    frame = @@frames.new

    frame.setSize(400,400)
    frame.setLocation((@@toolkits.getScreenSize().getWidth  - 400) / 2 , (@@toolkits.getScreenSize().getHeight - 400) / 2)

	button = javax.swing.JButton.new("Compile")
	button .setSize(100,100)
    mainPanel = @@panels.new(java.awt.GridLayout.new(2,1,5,5))
  	mainPanel.add(javax.swing.JTextArea.new)
    mainPanel.add(button)
    frame.add(mainPanel)
    frame.setDefaultCloseOperation(javax.swing.JFrame::EXIT_ON_CLOSE)

	frame.set_visible true

  end
  demo = Gui.new

end