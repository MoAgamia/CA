require 'java'

 java_import 'java.awt.event.ActionListener'
 java_import 'javax.swing.JButton'
 java_import 'javax.swing.JFrame'

 class ClickAction
  include ActionListener

  def actionPerformed(event)
    puts "Button got clicked."
  end
 end

 class MainWindow < JFrame
   def initialize
     super "JRuby/Swing Demo"
     setDefaultCloseOperation JFrame::EXIT_ON_CLOSE

     button = JButton.new( "Click me!") do |e|
    
      end
     button.addActionListener ClickAction.new
     add button
     pack
   end
 end

 MainWindow.new.setVisible true