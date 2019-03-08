{$UNITPATH\SDL2}
program VIVELESDL;

uses SDL2,crt, SDL2_image;

var
sdlWindow1 : PSDL_Window;
sdlRenderer : PSDL_Renderer;
sdlTexture1, sdlTexture2 : PSDL_Texture;
sdlRectanglePNG, sdlRectangleBMP, rectangle: TSDL_Rect;
sdlKeyBoardState : PUInt8;
compteur, xFenetre, yFenetre : integer;
Running : boolean;
sdlPoints: array[1..5000] of PSDL_Point;
PointsActif : array [1..5000] of boolean;

procedure dessinerPoints(quantite : integer);
//Permet d'afficher et de d‚placer les points … l'‚cran
//Prend comme valeur le nombre de points … afficher

var i: integer;
direction : integer;

begin
  randomize;
  SDL_SetRenderDrawColor(sdlRenderer, 255, 255, 255, 255);
  for i := 1 to quantite do
	begin
	direction := random(5);
		case direction of
			 1 : if (sdlPoints[i]^.x < xFenetre) then sdlPoints[i]^.x := sdlPoints[i]^.x + 1;
			 2 : if (sdlPoints[i]^.x > 0       ) then sdlPoints[i]^.x := sdlPoints[i]^.x - 1;
			 3 : if (sdlPoints[i]^.y < yFenetre) then sdlPoints[i]^.y := sdlPoints[i]^.y + 1;
			 4 : if (sdlPoints[i]^.y > 0       ) then sdlPoints[i]^.y := sdlPoints[i]^.y - 1;
		end;
	end;

	for i := 1 to quantite do
	begin
		if (sdlrectanglePNG.x <= sdlPoints[i]^.x) AND (sdlPoints[i]^.x <= sdlrectanglePNG.x + sdlrectanglePNG.w) AND (sdlPoints[i]^.y >= sdlrectanglePNG.y) AND (sdlPoints[i]^.y <= sdlrectanglePNG.y + rectangle.h) then
			PointsActif[i] := false;

		if PointsActif[i] = true then
			begin
			SDL_SetRenderDrawColor(sdlRenderer, 255 - sdlPoints[i]^.x DIV 3, sdlPoints[i]^.x DIV 3 + sdlPoints[i]^.y DIV 6 , 45 + sdlPoints[i]^.y DIV 4 + sdlPoints[i]^.x DIV 6, 255);
			SDL_RenderDrawPoint(sdlRenderer, sdlPoints[i]^.x, sdlPoints[i]^.y);
			end;
	end;


end;

FUNCTION AnyPointLeft(quantite : integer) : boolean;
//Renvoie TRUE s'il y a encore un point sur l'‚cran.
//prend comme valeur le nombre de points … analyser.
var i: integer;
restant : boolean;

begin
restant := false;
	for i := 1 to quantite do
	begin
		if PointsActif[i] = true then
			restant := true;
	end;
AnyPointLeft := restant;
end;

procedure genererPoints(quantite : integer);
//G‚nŠre un nombre quantite de points.


var
  i:integer;

begin

  randomize;
  for i := 1 to quantite do
  begin
    new( sdlPoints[i] );
	PointsActif[i] := true;
    sdlPoints[i]^.x := random(xFenetre);
    sdlPoints[i]^.y := random(yFenetre);
  end;


end;


begin
writeln('Bienvenue dans le programme aspirateur. Deplacez vous avez ZQSD et capturez toutes les lucioles. Bonne chance');
//Taille de la fenêtre
xFenetre := 500;
yFenetre := 500;
compteur := 0;

  //initilization of video subsystem
  if SDL_Init( SDL_INIT_VIDEO ) < 0 then HALT;

  sdlWindow1 := SDL_CreateWindow( 'Window1', 50, 50, xFenetre, yFenetre, SDL_WINDOW_SHOWN );
  if sdlWindow1 = nil then HALT;

  sdlRenderer := SDL_CreateRenderer( sdlWindow1, -1, 0 );
  if sdlRenderer = nil then HALT;

  sdlTexture1 := IMG_LoadTexture( sdlRenderer, 'images/rider.bmp' );
  sdlTexture2 := IMG_LoadTexture( sdlRenderer, 'images/helicopter.png' );

  if sdlTexture1 = nil then HALT;

  //"rectangles" des images
  sdlRectangleBMP.x := 50;
  sdlRectangleBMP.y := 0;
  sdlRectangleBMP.w := 123;
  sdlRectangleBMP.h := 87;

  rectangle.x := 0;
  rectangle.y := 0;
  rectangle.w := 128;
  rectangle.h := 55;

  sdlRectanglePNG.x := 100;
  sdlRectanglePNG.y := 150;
  sdlRectanglePNG.w := 128;
  sdlRectanglePNG.h := 55;
  Running := true;
 genererPoints(5000);
  while Running = True do
  begin


	rectangle.x := (compteur DIV 4) MOD 4 * 128;
    SDL_PumpEvents;
    sdlKeyboardState := SDL_GetKeyboardState(nil);

    // Quitter avec ESC
    if sdlKeyboardState[SDL_SCANCODE_ESCAPE] = 1 then
      Running := False;


    // Touches ZQSD
    if (sdlKeyboardState[SDL_SCANCODE_W] = 1) AND (sdlRectanglePNG.y > 0) then
      sdlRectanglePNG.y := sdlRectanglePNG.y-3;
    if (sdlKeyboardState[SDL_SCANCODE_A] = 1) AND (sdlRectanglePNG.x > 0) then
      sdlRectanglePNG.x := sdlRectanglePNG.x-3;
    if (sdlKeyboardState[SDL_SCANCODE_S] = 1) AND (sdlRectanglePNG.y + sdlRectanglePNG.h < yFenetre) then
      sdlRectanglePNG.y := sdlRectanglePNG.y+3;
    if (sdlKeyboardState[SDL_SCANCODE_D] = 1)AND (sdlRectanglePNG.x + sdlRectangleBMP.w < xFenetre ) then
      sdlRectanglePNG.x := sdlRectanglePNG.x+3;


  // black background
  SDL_SetRenderDrawColor(sdlRenderer, 0, 0, 0, SDL_ALPHA_OPAQUE);
  SDL_RenderClear(sdlRenderer);
  //Affichage des points
  dessinerPoints(5000);
  SDL_RenderCopy( sdlRenderer, sdlTexture1, nil, @sdlRectangleBMP );
  SDL_RenderCopy( sdlRenderer, sdlTexture2, @rectangle, @sdlRectanglePNG );
  
  //Reset des points sur la carte
  if ( AnyPointLeft(5000) = false ) then
	begin
	genererPoints(5000);
	end;
  SDL_RenderPresent (sdlRenderer);

  SDL_RenderPresent(sdlRenderer);
	compteur := compteur + 1;
	delay(20);
  end;


  SDL_DestroyTexture( sdlTexture1 );
  SDL_DestroyTexture( sdlTexture2 );
  SDL_DestroyRenderer( sdlRenderer );
  SDL_DestroyWindow ( sdlWindow1 );

  //shutting down video subsystem
  SDL_Quit;

end.
