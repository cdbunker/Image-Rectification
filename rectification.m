clear all
close all

img_cell = cell(1,10);

frame = 'building.jpg';
img = imread(frame);

p11 = [194, 311, 1]';
p21 = [677,353, 1]';

p31 = [163,496, 1]';
p41 = [702,485, 1]';

p51 = [688,302, 1]';
p61 = [703,484, 1]';

p71 = [194,267, 1]';
p81 = [194,480, 1]';

l1 = cross(p11, p21);
l2 = cross(p31, p41);
l3 = cross(p51, p61);
l4 = cross(p71, p81);
s = size(img);

%%%%%%%%%%%%%%%%

p_inf1 = cross(l1,l2);
p_inf2 = cross(l3,l4);

l_inf = cross(p_inf1, p_inf2);
l_inf = l_inf / norm(l_inf);
l_inf = l_inf / l_inf(3);

H = [1, 0, 0; 0, 1, 0];
H(3,:) = l_inf';

boundaries = [1, s(2), s(2), 1; 1, 1, s(1), s(1),; 1, 1, 1, 1];
tl=H*boundaries(:,1);
tl=tl/tl(3);
tr=H*boundaries(:,2);
tr=tr/tr(3);
br=H*boundaries(:,3);
br=br/br(3);
bl=H*boundaries(:,4);
bl=bl/bl(3);
point_boundaries = [tl';tr';br';bl'];
new_boundaries = ceil([max(point_boundaries(:,1)), max(point_boundaries(:,2))]);

    figure;
    imshow(img);
    hold on;
    plot([p11(1),p21(1)],[p11(2),p21(2)],'Color','r','LineWidth',2)
    plot([p31(1),p41(1)],[p31(2),p41(2)],'Color','r','LineWidth',2)
    plot([p51(1),p61(1)],[p51(2),p61(2)],'Color','r','LineWidth',2)
    plot([p71(1),p81(1)],[p71(2),p81(2)],'Color','r','LineWidth',2)

final_img = uint8(zeros(new_boundaries(2), new_boundaries(1), 3));

for x=1: new_boundaries(1)
    for y=1: new_boundaries(2)
        xy = [x, y, 1]';
        original_point = H\xy;
        original_point = round(original_point/original_point(3));
        
        if (original_point(1) < s(2) && original_point(2) < s(1))
            if (original_point(1) > 0 && original_point(2) > 0)
                final_img(y, x, :) = img(original_point(2), original_point(1),:);
            end
        end
    end
end

p12 = [161,491, 1]';
p22 = [166,242, 1]';

p32 = [185,230, 1]';
p42 = [680,294, 1]';

p52 = [285,375, 1]';
p62 = [301,397, 1]';

p72 = [300,376, 1]';
p82 = [286,396, 1]';

    figure;
    imshow(final_img);
    hold on;
    plot([p12(1),p22(1)],[p12(2),p22(2)],'Color','g','LineWidth',2)
    plot([p32(1),p42(1)],[p32(2),p42(2)],'Color','g','LineWidth',2)
    plot([p52(1),p62(1)],[p52(2),p62(2)],'Color','g','LineWidth',2)
    plot([p72(1),p82(1)],[p72(2),p82(2)],'Color','g','LineWidth',2)

pl1 = cross(p12,p22);
pm1 = cross(p32,p42);
pl2 = cross(p52,p62);
pm2 = cross(p72,p82);

l11 = pl1(1);
l12 = pl1(2);
l21 = pl2(1);
l22 = pl2(2);
m11 = pm1(1);
m12 = pm1(2);
m21 = pm2(1);
m22 = pm2(2);

orth1 = [l11*m11, l11*m12 + l12*m11, l12*m12];
orth2 = [l21*m21, l21*m22 + l22*m21, l22*m22];

orthT = [orth1; orth2];

s = null(orthT);
s11 = s(1);
s12 = s(2);
s22 = s(3);

S = [s11, s12; s12, 1];

[U, D, V] = svd(S);
A = U'*sqrt(D)*U;
K = chol(S, 'lower');
%A=K;
H2 = [A, [0;0]; [0,0,1]];

int_boundaries = [1, new_boundaries(1); 1, new_boundaries(2); 1, 1];
final_boundaries = H2\int_boundaries(:,2);
final_boundaries = ceil(final_boundaries/final_boundaries(3));

rect_img = uint8(zeros(final_boundaries(2), final_boundaries(1), 3));

for x = 1:final_boundaries(1)
    for y = 1:final_boundaries(2)
        xy = [x, y, 1]';
        
        original_point = H2*xy;
        original_point = round(original_point/original_point(3));
        if (original_point(1) > 0 && original_point(2) > 0)
            if (original_point(1) < new_boundaries(1) && original_point(2) < new_boundaries(2))
                rect_img(y, x, :) = final_img(original_point(2), original_point(1), :);
            end
        end
    end
end

figure();
imshow(rect_img);
