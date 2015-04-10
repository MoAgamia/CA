require 'java'

 java_import 'java.awt.event.ActionListener'
 java_import 'javax.swing.JButton'
 java_import 'javax.swing.JFrame'
 java_import 'javax.swing.JTextArea'
 java_import 'javax.swing.JPanel'

class ButtonListener 
	include ActionListener

	def actionPerformed(e)
		puts "clicked"
	end
end


class Gui

  @@toolkits = java.awt.Toolkit.getDefaultToolkit()
  
  def initialize
    frame = JFrame.new

    frame.setSize(400,400)
    frame.setLocation((@@toolkits.getScreenSize().getWidth  - 400) / 2 , (@@toolkits.getScreenSize().getHeight - 400) / 2)

	button = javax.swing.JButton.new("Compile")
	
	button = JButton.new( "Click me!") 
	
	textArea = JTextArea.new	
		
	
    mainPanel = JPanel.new(java.awt.GridLayout.new(2,1,5,5))
  	mainPanel.add(javax.swing.JTextArea.new)



    buttonAction = ButtonListener.new
    button.addActionListener buttonAction

    mainPanel.add(button)

    frame.add(mainPanel)
    frame.setDefaultCloseOperation(javax.swing.JFrame::EXIT_ON_CLOSE)

	frame.set_visible true

  end
  demo = Gui.new

end




