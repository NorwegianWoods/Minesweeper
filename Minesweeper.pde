import de.bezier.guido.*;
public static int NUM_ROWS = 20;
public static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLS; col++) {
            buttons [row] [col] = new MSButton(row, col);
        }
    }
    setBombs();
}
public void setBombs()
{
    while (bombs.size() < 25) {
        int row = (int)(Math.random()*NUM_ROWS);
        int col = (int)(Math.random()*NUM_COLS);
        if (!bombs.contains(buttons[row][col])) {
            bombs.add(buttons[row][col]);
        }
    }
}
public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    for(int i = 0; i < NUM_ROWS; i++){
        for(int j = 0; j < NUM_COLS; j++){
            if(buttons[i][j].isClicked() == false && bombs.contains(buttons[i][j]) == false){
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2-4].setLabel("F");
    buttons[NUM_ROWS/2][NUM_COLS/2-3].setLabel("a");
    buttons[NUM_ROWS/2][NUM_COLS/2-2].setLabel("i");
    buttons[NUM_ROWS/2][NUM_COLS/2-1].setLabel("l");
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("u");
    buttons[NUM_ROWS/2][NUM_COLS/2+1].setLabel("r");
    buttons[NUM_ROWS/2][NUM_COLS/2+2].setLabel("e");
    buttons[NUM_ROWS/2][NUM_COLS/2+3].setLabel("!");
}
public void displayWinningMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2-4].setLabel("V");
    buttons[NUM_ROWS/2][NUM_COLS/2-3].setLabel("i");
    buttons[NUM_ROWS/2][NUM_COLS/2-2].setLabel("c");
    buttons[NUM_ROWS/2][NUM_COLS/2-1].setLabel("t");
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("o");
    buttons[NUM_ROWS/2][NUM_COLS/2+1].setLabel("r");
    buttons[NUM_ROWS/2][NUM_COLS/2+2].setLabel("y");
    buttons[NUM_ROWS/2][NUM_COLS/2+3].setLabel("!");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton == RIGHT) {
            marked = !marked;
            if (marked == false) {
                clicked = false;
            }
        } else if (mouseButton == LEFT && bombs.contains(this)) {
            displayLosingMessage();
        } else if (this.countBombs(r, c) > 0) {
            label = "" + this.countBombs(r, c);
        } else {
            if(isValid(r,c - 1) && !buttons[r][c - 1].isClicked())
                buttons[r][c - 1].mousePressed();
            if(isValid(r,c + 1) && !buttons[r][c + 1].isClicked())
                buttons[r][c + 1].mousePressed();
            if(isValid(r - 1,c) && !buttons[r - 1][c].isClicked())
                buttons[r - 1][c].mousePressed();
            if(isValid(r + 1,c) && !buttons[r + 1][c].isClicked())
                buttons[r + 1][c].mousePressed();
            if(isValid(r - 1,c - 1) && !buttons[r - 1][c - 1].isClicked())
                buttons[r - 1][c - 1].mousePressed();
            if(isValid(r + 1,c + 1) && !buttons[r + 1][c + 1].isClicked())
                buttons[r + 1][c + 1].mousePressed();
            if(isValid(r - 1,c + 1) && !buttons[r - 1][c + 1].isClicked())
                buttons[r - 1][c + 1].mousePressed();
            if(isValid(r + 1,c - 1) && !buttons[r + 1][c - 1].isClicked())
                buttons[r + 1][c - 1].mousePressed();
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill(100);

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
            return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int x = row - 1; x <= row + 1; x++){
            for(int y = col - 1; y <= col + 1; y++){
                if(isValid(x,y) == true){
                    if(bombs.contains(buttons[x][y])){
                        numBombs = numBombs +1;
                    }
                }
            }
        }
        return numBombs;
    }
}
