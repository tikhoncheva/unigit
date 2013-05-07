function mat2tex(A)

s = '';
[m,n] = size(A);

for row=1:m
	for col=1:n
		s = [s sprintf('%d ',A(row,col))];
		if col < n
			s = [s ' & '];
		end
	end
	
	if row < m
		s = [s ' \\\\ \n'];
	else
		s = [s ' \n'];
	end

end

disp(sprintf(s))

end
