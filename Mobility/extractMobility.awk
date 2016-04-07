# awk -f analysis.awk simple.tr > outputfile

BEGIN{

	TCPsent = 0;
	AODVsent = 0;
	dropPackets = 0;
	TCPdropPackets = 0;
}

{
	if ($3 == "X_" || $3 == "Y_" || $3 == "Z_") {
		printf($0);
		printf("\n");
	}
	
	if($5 == "setdest") {
		printf($0);
		printf("\n");
	}
	
}

END{
	printf("\n");
}


