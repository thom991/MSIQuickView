combine_uz4s = [];
% matr = rand(8,5);
% matr = [1,2,3,4,5;2,4,9,16,30;3,6,18,32,60;4,8,9,16,30];
% matr(5:8,:) = matr*10;
% uz = [5,6,10,15,17,19,20,30];
% uz4 = [];
uz4_new = [];
final_mz_new = [];
% uz4 = uz;
count = 1;
for i = 1:size(uz4,2)-1
    val1 = uz4(i);
    val2 = uz4(i+1);
    if (val2-val1) < 10;%user_entered_val;
        uz4_new(i) = val1;
        combine_uz4s(count) = i;
        count = count + 1;
        uz4(i+1) = val1;
    else
        uz4_new(i) = val1;
        uz4_new(i+1) = val2;
    end
end
[final_mz_new,m,n] = unique(uz4_new);
matr = matrix_start;
% for i = 1:size(combine_uz4s,2)
%     A = [];
%     current_combine_val = combine_uz4s(i);
%     current_uz_val = uz4(combine_uz4s(i));
% %     [c,ia,ib] = intersect(uz4_new,current_uz_val);
%     for i2 = 1:size(find(uz4 == current_uz_val),2)
%     A(i2,:) = matr(combine_uz4s(i)+(i2-1),:);
%     end
%     matr(current_combine_val,:) = mean(A);
%     rep_times(i) = size(find(uz4 == current_uz_val),2);
% end
% for i = 1:size(combine_uz4s,2)
% %     A = [];
%     current_combine_val = combine_uz4s(i);
%     current_uz_val = uz4(combine_uz4s(i));
% %     [c,ia,ib] = intersect(uz4_new,current_uz_val);
%     for i2 = 1:size(find(uz4 == current_uz_val),2)-1
%     matr(combine_uz4s(i)+(i2),:) = NaN;
%     end
% %     matr(current_combine_val,:) = mean(A,2);
% end
    matr_new = zeros(size(m,2),size(matr,2),'single');
for i = 1:size(m,2)
    if i == 1
    matr_new(i,:) = mean(matr((1:m(i)),:));
    else
    if (m(i-1)+1) < m(i)
    matr_new(i,:) = mean(matr((m(i-1)+1:m(i)),:));  
    else
    matr_new(i,:) = (matr((m(i-1)+1:m(i)),:));      
    end
    end
end