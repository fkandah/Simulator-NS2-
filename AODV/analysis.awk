# awk -f analysis.awk simple.tr > outputfile

BEGIN{

	TCPsent = 0;
	AODVsent = 0;
	dropPackets = 0;
	TCPdropPackets = 0;
}

{
	if ($7 == "tcp" && $8 == 1040) TCPsent+=1;
	if ($7 == "AODV") {
		AODVsent+=1;
		#printf($2);
	}

	if ($1 == "D" && $7 == "tcp") TCPdropPackets += 1;
	if ($1 == "D") dropPackets += 1;
	if ($1 == "M") {
		printf($0);
		printf("\n");
	}
}

END{
	printf("\n");
	printf("Number of tcp packets (1040) sent = %d \n", TCPsent);
	printf("Number of AODV packets sent = %d \n", AODVsent);
	printf("Number of dropped packets = %d \n", dropPackets);
	printf("Number of TCP dropped packets = %d \n\n", TCPdropPackets);
}


