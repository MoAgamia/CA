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
java_import 'java.awt.GridLayout'
java_import 'java.awt.Dimension'

class CompileListener
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

class NextListener
    include ActionListener

    @name

    def initialize text
        @name = text
    end

    def actionPerformed(e)
        text = @name.getText
        datapath = Datapath.new
        datapath.load_instructions text
    end
end


class Gui

    @@toolkits = java.awt.Toolkit.getDefaultToolkit()
    @@datapath =  Datapath.new

    def initialize
        frame = JFrame.new("MIPS pipelined simulator")
        frame.setMinimumSize(Dimension.new(800,800))
        frame.setLocation((@@toolkits.getScreenSize().getWidth  - 400) / 2 , (@@toolkits.getScreenSize().getHeight - 400) / 2)

        registersPanel = JPanel.new(GridLayout.new(10,1))
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

        t0 = JLabel.new("$t0")
        t1 =JLabel.new("$t1")
        t2 =JLabel.new("$t2")
        t3 =JLabel.new("$t3")
        t4 =JLabel.new("$t4")
        t5 =JLabel.new("$t5")
        t6 =JLabel.new("$t6")
        t7 =JLabel.new("$t7")
        t8 =JLabel.new("$t8")
        t9 =JLabel.new("$t9")



        registersPanel.add(t0)
        registersPanel.add(t1)
        registersPanel.add(t2)
        registersPanel.add(t3)
        registersPanel.add(t4)
        registersPanel.add(t5)
        registersPanel.add(t6)
        registersPanel.add(t7)
        registersPanel.add(t8)
        registersPanel.add(t9)

        constraints.fill = GridBagConstraints::BOTH
        constraints.gridx = 2
        constraints.gridy = 0
        constraints.weightx = 1.0
        constraints.weighty = 1.0
        constraints.gridheight = 2
        mainPanel.add(registersPanel,constraints)

        compileAction = CompileListener.new textArea
        compile.addActionListener compileAction

        frame.add(mainPanel)
        frame.setDefaultCloseOperation(javax.swing.JFrame::EXIT_ON_CLOSE)
        frame.set_visible true

    end

    demo = Gui.new

end




