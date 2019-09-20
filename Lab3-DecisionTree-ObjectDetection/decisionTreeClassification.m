path = uigetdir
files = dir (fullfile(path,'\*.png'));

L = length (files);
classes = {'apple','car','cow','cup','dog','horse','pears','tomato'};
    classes = string(classes);
for i=1:L
   orgImage=imread(fullfile(path,'\',files(i).name));   
   % process the image in here
   
   grayImg= rgb2gray(orgImage);
   %grayImg = im2double(grayImg);
   %image{i} = grayImg;
   features(i,:) = extractLBPFeatures(grayImg);
   
   for j=1:8
       k = strfind(files(i).name,classes(1,j));
       if ~isempty(k)
           label(i,1)=classes(1,j);
           break;
       end 
    end


end

tab = array2table(features);

tc = fitctree(tab,label);

path = uigetdir
files = dir (fullfile(path,'\*.png'));
L = length (files);

for i=1:L
   orgImage=imread(fullfile(path,'\',files(i).name));   
   % process the image in here
   
   grayImg= rgb2gray(orgImage);
   %grayImg = im2double(grayImg);
   %image{i} = grayImg;
   features(i,:) = extractLBPFeatures(grayImg);

end

result = predict(tc,features);
%writetable(table(features),'features.xlsx');
matData = table(result);
%tabData = cell2table(data);
%matData = struct2table(matData);
writetable(matData,'res.xlsx');