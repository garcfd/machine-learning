
      program main
      implicit none

      integer i,j,it
      INTEGER, PARAMETER :: nt = 7 ! number of training data


      real tsi(nt,3),       tso(nt),       tsi_trans(3,nt)
      real output1(nt,4),   output2(nt)
      real sigmoid1(nt,4),  sigmoid2(nt),  sigmoid1_trans(4,nt)
      real sig_der1(nt,4),  sig_der2(nt)
      real layer1(3,4),     layer2(4)
      real error1(nt,4),    error2(nt)
      real delta1(nt,4),    delta2(nt)
      real adjust1(3,4),    adjust2(4)

      real test_input(3),test_output
      

      tsi(1,:) = [0, 0, 1]
      tsi(2,:) = [0, 1, 1]
      tsi(3,:) = [1, 0, 1]
      tsi(4,:) = [0, 1, 0]
      tsi(5,:) = [1, 0, 0]
      tsi(6,:) = [1, 1, 1]
      tsi(7,:) = [0, 0, 0]

      tso = [0, 1, 1, 1, 1, 0, 0]
      tsi_trans = transpose(tsi)

C-----random weights
      if (.false.) then
      call srand(12345)
      do i = 1,3 ! wts
        do j = 1,4 ! neurons
          layer1(i,j) = 2.0 * rand() - 1
        enddo
      enddo
      do j = 1,4 ! wts
        layer2(j)   = 2.0 * rand() - 1
      enddo
      endif

C-----specific random weights (true/false)
      if (.false.) then
      layer1(1,:) = [-0.16595599, 0.44064899,-0.99977125,-0.39533485]
      layer1(2,:) = [-0.70648822,-0.81532281,-0.62747958,-0.30887855]
      layer1(3,:) = [-0.20646505, 0.07763347,-0.16161097, 0.370439  ]
      layer2(:)   = [-0.5910955 , 0.75623487,-0.94522481, 0.34093502]
      endif

C-----uniform weights (true/false)
      if (.true.) then
        layer1 = 0.1 
        layer2 = 0.1
      endif

      write(6,'(1X,A,4F9.4)')"layer1 = ",(layer1(1,i),i=1,4)
      write(6,'(1X,A,4F9.4)')"layer1 = ",(layer1(2,i),i=1,4)
      write(6,'(1X,A,4F9.4)')"layer1 = ",(layer1(3,i),i=1,4)
      write(6,'(1X,A,4F9.4)')"layer2 = ",(layer2(i),  i=1,4)

      write(6,*)"Training: "

C-----TRAINING the neural network
      open(10,file="output.dat")
      do it = 1,10000

        do i = 1,nt ! loop over number of rows of input data

C---------output_from_layer1 = self.__sigmoid(dot(inputs, self.layer1.synaptic_weights))
          do j = 1,4 ! neurons
            output1(i,j)  = dot_product(tsi(i,:), layer1(:,j))
            sigmoid1(i,j) = 1.0 / (1.0 + exp( -output1(i,j) ))
          enddo
          sig_der1(i,:) = sigmoid1(i,:) * (1.0 - sigmoid1(i,:) ) ! sigmoid derivative

C---------output_from_layer2 = self.__sigmoid(dot(output_from_layer1, self.layer2.synaptic_weights))
          output2(i)  = dot_product(sigmoid1(i,:),layer2)
          sigmoid2(i) = 1.0 / (1.0 + exp( -output2(i) ))
          sig_der2(i) = sigmoid2(i) * (1.0 - sigmoid2(i))

C---------calc delta layer2
          error2(i) = tso(i) - sigmoid2(i)
          delta2(i) = error2(i) * sig_der2(i)

C---------calc delta layer1
          error1(i,:) = delta2(i) * layer2
          delta1(i,:) = error1(i,:) * sig_der1(i,:)

        enddo ! nt training data loop

C-------debugging output
        if (.false.) then
        do i = 1,nt
         write(6,*)"out1",sigmoid1(i,:)
        enddo
        do i = 1,nt
         write(6,*)"out2",sigmoid2(i)
        enddo
        do i = 1,nt
          write(6,*) "error2",error2(i)
        enddo
        do i = 1,nt
          write(6,*) "delta2",delta2(i)
        enddo
        do i = 1,nt
          write(6,'(1X,A,4F12.7)') "error1",error1(i,:)
        enddo
        do i = 1,nt
          write(6,'(1X,A,4F12.7)') "delta1",delta1(i,:)
        enddo
        endif

C-------adjust weights layer1
        do i = 1,3 ! weights
          adjust1(i,:) = dot_product(tsi_trans(i,:), delta1(:,i) )
          do j = 1,4 ! neurons
            layer1(i,j) = layer1(i,j) + adjust1(i,j)
          enddo
C         write(6,'(1X,A,4F12.7)') "adjust1 ", adjust1(i,:)
        enddo

        sigmoid1_trans = transpose(sigmoid1)

C-------adjust weights layer2
        do i = 1,4 ! weights
          adjust2(i) = dot_product(sigmoid1_trans(i,:),delta2)
          layer2(i)  = layer2(i) + adjust2(i)
        enddo
C       write(6,'(1X,A,4F12.7)') "adjust2 ", adjust2

C-------data to screen and output file
        write(6, '(I5,4F9.4)') it,layer2
        write(10,'(I5,4F9.4)') it,layer2

      enddo
      close(10)

      write(6,*)"New synaptic weights after training: "
      write(6,'(1X,A,4F9.4)')"layer1 = ",(layer1(1,i),i=1,4)
      write(6,'(1X,A,4F9.4)')"layer1 = ",(layer1(2,i),i=1,4)
      write(6,'(1X,A,4F9.4)')"layer1 = ",(layer1(3,i),i=1,4)
      write(6,'(1X,A,4F9.4)')"layer2 = ",(layer2(i),  i=1,4)

C-----TESTING the neural network with a new input
      test_input = [1, 1, 0]
      do j = 1,4 ! neurons
        output1(i,j)  = dot_product(test_input, layer1(:,j))
        sigmoid1(i,j) = 1.0 / (1.0 + exp( -output1(i,j) ))
      enddo
      output2(i)  = dot_product(sigmoid1(i,:),layer2)
      test_output = 1.0 / (1.0 + exp( -output2(i) ))

      write(6,*)"test_input=", test_input  
      write(6,*)"test_output=", test_output  

      end program

