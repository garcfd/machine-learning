
      program main
      implicit none

      integer i,it

      real tsi(4,3),tsi_trans(3,4),tso(4),weight(3),adjust(3)
      real output(4),sigmoid(4),sig_der(4),error(4),test_input(3)
      real test_output

      tsi(1,:) = [0, 0, 1]
      tsi(2,:) = [1, 1, 1]
      tsi(3,:) = [1, 0, 1]
      tsi(4,:) = [0, 1, 1]
      tso(:)   = [0, 1, 1, 0]

      tsi_trans = transpose(tsi)

      weight(1) = 2.0 * rand() - 1
      weight(2) = 2.0 * rand() - 1
      weight(3) = 2.0 * rand() - 1

CCC   weight = [0.1,0.1,0.1] ! fix weights for testing only
      write(6,*)"weight = ",weight

C-----training the neural network
      open(10,file="output.dat")
      do it = 1,10000

        do i = 1,4 ! loop over number of rows of input data
          output(i)  = dot_product(tsi(i,:),weight)
          sigmoid(i) = 1.0 / (1.0 + exp( -output(i) ))
          sig_der(i) = sigmoid(i) * (1.0 - sigmoid(i) )
          error(i)   = tso(i) - sigmoid(i)
        enddo

C-------adjust weights
        do i = 1,3 ! loop over number of weights
          adjust(i) = dot_product(tsi_trans(i,:), error*sig_der)
          weight(i) = weight(i) + adjust(i)
        enddo

        write(6,*) it,weight
        write(10,*) it,weight

      enddo
      close(10)

      write(6,*)
      write(6,*)"New synaptic weight after training: "
      write(6,*) "weight = ",weight

C-----test the neural network with a new input.
      test_input = [1, 0, 0]
      test_output = dot_product(test_input,weight)
      test_output = 1.0 / (1.0 + exp( -test_output ))

      write(6,*)"test_input=", test_input  
      write(6,*)"test_output=", test_output  

      end program

