% Un programa hecho para aprender alemán

german = importdata("german.txt");
english = importdata("english.txt");
box_eng = {};
box_ger = {};
n = 0;

while true
    whal = input('Option 1: Display a new word\nOption 2: End programm\nChosen option: ');
    if whal == 2
        break
    end
    word = randi([1 length(german)]);
    disp('.............')
    disp(english{word})
    disp('.............')
    korrekt = input('Option 1: Display the traduction\nOption 2: Send it to the unknown-words-box\nChosen option: ');
    if korrekt == 1
        disp('.............')
        disp(german{word})
        disp('.............')
    else
        n = n+1;
        box_eng{end+1} = strcat(num2str(n),'.- ',english{word});
        box_ger{end+1} = strcat(num2str(n),'.- ',german{word});
    end
    box = input('Option 1: Continue\nOption 2: Check the words in the unknown-words-box\nChosen option: ');
    if box == 2
        stimmt = true;
        while stimmt == true
            disp('This is the unknown-words-box:')
            for i = 1:length(box_eng)
                disp(box_eng{i})
            end
            show = input('Enter the number of the word to show its traduction\nEnter 0 to skip this part\nEnter -1 to show every traduction\nChosen option: ');
            if show == -1
                for i = 1:length(box_ger)
                    disp(box_ger{i})
                end
                box_eng = {};
                box_ger = {};
                stimmt = false;
                n = 0;
            elseif show == 0
                stimmt = false;
            else
                disp('.............')
                disp(box_ger{show})
                disp('.............')
                box_eng{show} = {};
                box_ger{show} = {};
            end
        end
    end
end