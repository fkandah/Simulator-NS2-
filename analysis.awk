BEGIN{

TCPsent = 0;
}

{
if ($7 == "tcp") TCPsent+=1;
}

END{
printf("Number of tcp packets sent = %d \n\n", TCPsent);
}

