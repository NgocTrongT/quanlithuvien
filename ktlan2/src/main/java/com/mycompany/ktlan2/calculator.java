/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.ktlan2;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
/**
 *
 * @author Admin
 */
public class calculator implements ActionListener {
     
     JFrame frame;
    JTextField textfield;
    JButton[] numberButtons = new JButton[10];
    JButton[] functionButtons = new JButton[9];
    JButton addButton, subButton, mulButton, divButton;
    JButton decButton, equButton, delButton, clrButton, negButton;
    JPanel panel, panel1;

    Font myFont = new Font("Times New Roman", Font.BOLD, 15);

    double num1 = 0, num2 = 0, result = 0;
    char operator;

    calculator() {

        frame = new JFrame("Calculator");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(550, 400);
        frame.setLayout(null);

        textfield = new JTextField();
        textfield.setBounds(50, 25, 300, 50);
        textfield.setFont(myFont);
        textfield.setEditable(false);

        addButton = new JButton("+");

        decButton = new JButton(".");
        equButton = new JButton("=");
        delButton = new JButton("Del");
        clrButton = new JButton("Clear");
        negButton = new JButton("(-)");

        functionButtons[0] = addButton;

        functionButtons[1] = decButton;
        functionButtons[2] = equButton;

        functionButtons[3] = clrButton;


        for (int i = 0; i < 4; i++) {
            functionButtons[i].addActionListener(this);
            functionButtons[i].setFont(myFont);
            functionButtons[i].setFocusable(false);
        }

        for (int i = 0; i < 10; i++) {
            numberButtons[i] = new JButton(String.valueOf(i));
            numberButtons[i].addActionListener(this);
            numberButtons[i].setFont(myFont);
            numberButtons[i].setFocusable(false);
        }

        panel = new JPanel();
        panel.setBounds(50, 100, 300, 200);
        panel.setLayout(new GridLayout(4, 3, 40, 20));

        panel.add(numberButtons[1]);
        panel.add(numberButtons[2]);
        panel.add(numberButtons[3]);

        panel.add(numberButtons[4]);
        panel.add(numberButtons[5]);
        panel.add(numberButtons[6]);

        panel.add(numberButtons[7]);
        panel.add(numberButtons[8]);
        panel.add(numberButtons[9]);

        panel.add(numberButtons[0]);

        panel.add(decButton);

        panel1 = new JPanel();
        panel1.setBounds(400, 100, 80, 150);
        panel1.setLayout(new GridLayout(3, 1, 30, 30));

        panel1.add(addButton);
panel1.add(equButton);
        panel1.add(clrButton);

        frame.add(panel);
        frame.add(panel1);
        frame.add(textfield);
        frame.setVisible(true);
    }

    public static void main(String[] args) {

        calculator calc = new calculator();
    }

    @Override
    public void actionPerformed(ActionEvent e) {

        for (int i = 0; i < 10; i++) {
            if (e.getSource() == numberButtons[i]) {
                textfield.setText(textfield.getText().concat(String.valueOf(i)));
            }
        }
        if (e.getSource() == decButton) {
            textfield.setText(textfield.getText().concat("."));
        }
        if (e.getSource() == addButton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = '+';
            textfield.setText("");

        }
//        
        if (e.getSource() == equButton) {
            num2 = Double.parseDouble(textfield.getText());

            switch (operator) {
                case '+':
                    result = num1 + num2;
                    break;
              
            }
            textfield.setText(String.valueOf(result));
            num1 = result;

        }
        if (e.getSource() == clrButton) {
            textfield.setText("");
        }
        
    }
    
}
